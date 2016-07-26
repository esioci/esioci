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
                    status = parse_github(msg)
                              |> clone
                              |> parse_yaml
                    Logger.debug status
                    EsioCi.Common.change_bld_status(build_id, "COMPLETED")
                    Logger.info "Build completed"
            _ ->
              Logger.error "Only github is supported"
              Logger.error "Build failed"
              EsioCi.Common.change_bld_status(build_id, "FAILED")
          end
        rescue
          e in RuntimeError -> EsioCi.Common.change_bld_status(build_id, "FAILED")
        end

    end
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
    if File.exist?(yaml_file) do
      try do
        [yaml | _] = :yamerl_constr.file(yaml_file)
        [build | _] = :proplists.get_value('build', yaml)
        build_cmd = :proplists.get_value('exec', build) |> List.to_string
        EsioCi.Common.run(build_cmd, dst)
      rescue
        e in MatchError -> Logger.error "dupa!"
                           :error
      end
    else
      Logger.error "yaml file: #{yaml_file} doesn't exist"
      :error
    end
  end

end
