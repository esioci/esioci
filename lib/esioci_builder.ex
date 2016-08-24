defmodule EsioCi.Builder do
  require Logger
  require Poison

  def build do
    receive do
      {sender, msg, build_id, type} ->
        try do
          case type do
            "gh" -> Logger.debug "Run build from github"
                    EsioCi.Common.change_bld_status(build_id, "RUNNING")
                    status = msg
                              |> parse_github
                              |> clone
                              |> parse_yaml
                    Logger.debug status
                    EsioCi.Common.change_bld_status(build_id, "COMPLETED")
                    Logger.info "Build completed"
            "bb" -> Logger.debug "Run build from bitbucket"
                    EsioCi.Common.change_bld_status(build_id, "RUNNING")
                    status = msg
                              |> parse_bitbucket
                              |> clone
                              |> parse_yaml
                    Logger.debug status
                    EsioCi.Common.change_bld_status(build_id, "COMPLETED")
                    Logger.info "Build completed"
            _ ->
              Logger.error "Unsupported build type"
              Logger.error "Build failed"
              EsioCi.Common.change_bld_status(build_id, "FAILED")
          end
        rescue
          e -> EsioCi.Common.change_bld_status(build_id, "FAILED")
        end

    end
  end

  def parse_bitbucket(req_json) do
    git_url    = req_json.params["repository"]["links"]["html"]["href"]
    commit_sha = nil
    repo_name  = req_json.params["repository"]["full_name"]
    Logger.debug "Repository url: #{git_url}"
    Logger.debug "Repository name: #{repo_name}"
    Logger.debug "Commit sha: #{commit_sha}"

    {:ok, git_url, repo_name, commit_sha}
  end

  def parse_github(req_json) do
    git_url     = req_json.params["repository"]["git_url"]
    commit_sha  = req_json.params["head_commit"]["id"]
    repo_name   = req_json.params["repository"]["full_name"]
    Logger.debug "Repository url: #{git_url}"
    Logger.debug "Repository name: #{repo_name}"
    Logger.debug "Commit sha: #{commit_sha}"

    {:ok, git_url, repo_name, commit_sha}
  end

  def clone({ok, git_url, repo_name, commit_sha}) do
    dst = "/tmp/build"
    cmd = "git clone #{git_url} #{dst}"
    EsioCi.Common.run("rm -rf #{dst}")
    EsioCi.Common.run(cmd)
    {:ok, dst}
  end

  def parse_yaml({ok, dst}) do
    Logger.debug "Parse yaml file"
    yaml_file = "#{dst}/esioci.yaml"
    Logger.debug yaml_file
    if File.exists?(yaml_file) do
      try do
        [yaml | _] = :yamerl_constr.file(yaml_file)
        Logger.debug "YAML from file: #{inspect yaml}"
        # get artifacts
        artifacts = yaml |> get_artifacts_from_yaml
        # get all build commands
        build_cmd = yaml |> get_bld_cmd_from_yaml
        Logger.debug "Build cmd: #{build_cmd}"
        if build_cmd != :error and is_list(build_cmd) do
          # check if build_cmd is a string
          if is_integer(List.first(build_cmd)) do
            cmd = build_cmd |> to_string
            EsioCi.Common.run(cmd, dst)
          else
            for one_cmd <- build_cmd do
              cmd = one_cmd |> to_string
              EsioCi.Common.run(cmd, dst)
            end
          end
        else
          Logger.error "Error get build_cmd from yaml"
          raise MatchError
          :error
        end
        if artifacts != nil do
          copy_artifacts(artifacts)
        end
        :ok
      rescue
        e -> Logger.error "Error parsing yaml"
                           raise MatchError
        #e in Protocol.UndefinedError -> Logger.error "Error parsing yaml"
                            #:error
      end
    else
      Logger.error "yaml file: #{yaml_file} doesn't exist"
      :error
    end
  end

  def get_bld_cmd_from_yaml(yaml) do
    build_cmds = :proplists.get_value('build', yaml)
    extract_cmd(build_cmds)
  end

  def get_artifacts_from_yaml(yaml) do
    try do
      artifacts = :proplists.get_value('artifacts', yaml) |> List.to_string
    rescue
      e -> Logger.info "No artifacts in yaml"
           nil
    end
  end

  defp copy_artifacts(src) do
    Logger.info "Copy build artifacts to artifacats directory"
    # TODO: refactoring, separate parse yaml and build beceause I need build_id here
    # Refactored build pipeline => start build in db => get yaml => run_cmd => store artifacts => complete build
    dst = Application.get_env(:esioci, :artifacts_dir, "/tmp")
    Logger.debug "Copy #{src} to #{dst}"
    File.cp_r src, dst
  end

  defp extract_cmd([]) do
    []
  end

  defp extract_cmd([head|tail]) do
    [{'exec', cmd }] = head
    cmd_str = cmd |> List.to_string
    [cmd] ++ extract_cmd(tail)
  end

end
