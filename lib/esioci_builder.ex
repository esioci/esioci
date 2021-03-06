defmodule EsioCi.Builder do
  @moduledoc """
  Build logic
  """
  require Logger
  require Poison

  def build do
    receive do
      {sender, msg, build_id, type, project, repo} ->
        try do
          case type do
            "gh" -> Logger.debug "Run build from github"
                    EsioCi.Common.change_bld_status(build_id, "RUNNING")
                    {:ok, artifacts_dir} = prepare_artifacts_dir build_id

                    log = "#{artifacts_dir}/build_#{build_id}.txt"
                    Logger.debug log
                    dst = "/tmp/build"
                    # parse github json and get info about build
                    {:ok, git_url, repo_name, commit_sha} = parse_github {:ok, msg}
                    # clone repository
                    {:ok, _} = clone {:ok, git_url, repo_name, commit_sha, dst}
                    # parse build yaml
                    {:ok, build_cmd, artifacts} = parse_yaml {:ok, dst}
                    Logger.debug inspect build_cmd
                    Logger.debug artifacts
                    :ok = build {:ok, dst, build_cmd, log}
                    EsioCi.Common.change_bld_status(build_id, "COMPLETED")
                    Logger.info "Build completed"
            "poller" -> Logger.debug "Run poller build"
                    EsioCi.Common.change_bld_status(build_id, "RUNNING")
                    {:ok, artifacts_dir} = prepare_artifacts_dir build_id

                    log = "#{artifacts_dir}/build_#{build_id}.txt"
                    Logger.debug log
                    dst = "/tmp/build"
                    {:ok, _} = clone {:ok, repo, project, nil, dst}
                    {:ok, build_cmd, artifacts} = parse_yaml {:ok, dst}
                    Logger.debug inspect build_cmd
                    Logger.debug artifacts
                    :ok = build {:ok, dst, build_cmd, log}
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

  def poller_build do
    receive do
      {sender, project, repo} ->
        Logger.error inspect repo
        Logger.debug "Create poller build for project: #{project}"
        {:ok, build_id} = add_build_to_db(project)
        pid = spawn(EsioCi.Builder, :build, [])
        send pid, {self, "Poller build", build_id, "poller", project, repo}
    end
  end

  # Add build to database for speciified project
  defp add_build_to_db(project) do
    {:ok, project_id} = EsioCi.Db.get_project_by_name(project)
    {:ok, build_id} = EsioCi.Db.add_build_to_db(project_id)
  end

  def prepare_artifacts_dir(build_id) do
  # This function prepare artifacts_dir variable and create artifacts dir if non exist
    artifacts_basedir = Application.get_env(:esioci, :artifacts_dir, "/tmp")
    artifacts_dir = Path.join(artifacts_basedir, inspect build_id)
    unless File.exists?(artifacts_dir) do
      File.mkdir_p artifacts_dir
    end
    {:ok, artifacts_dir}
  end

  def build({:ok, dst, build_cmd, log}) do
    for one_cmd <- build_cmd do
      cmd = one_cmd |> to_string
      {result, _} = EsioCi.Common.run(cmd, dst, log)
      unless result == :ok, do: raise EsioCiBuildFailed
    end
    :ok
  end

  def parse_github({:ok, req_json}) do
    git_url     = req_json.params["repository"]["git_url"]
    commit_sha  = req_json.params["head_commit"]["id"]
    repo_name   = req_json.params["repository"]["full_name"]
    Logger.debug "Repository url: #{git_url}"
    Logger.debug "Repository name: #{repo_name}"
    Logger.debug "Commit sha: #{commit_sha}"

    {:ok, git_url, repo_name, commit_sha}
  end

  def get_sha(path) do
    cmd = "git rev-parse HEAD"
    EsioCi.Common.run(cmd, path)
  end
  def clone({:ok, git_url, repo_name, commit_sha, dst}) do
    if dst, do: dst_dir = dst, else: dst_dir = "/tmp/#{repo_name}"
    cmd = "git clone #{git_url} #{dst_dir}"
    File.rm_rf(dst_dir)
    EsioCi.Common.run(cmd)
    { :ok, dst_dir }
  end

  def parse_yaml({:ok, dst}) do
    Logger.debug "Parse yaml file"
    yaml_file = "#{dst}/esioci.yaml"
    Logger.debug yaml_file
    if File.exists?(yaml_file) do
      [yaml | _] = :yamerl_constr.file(yaml_file)
      Logger.debug "YAML from file: #{inspect yaml}"
      # get artifacts
      artifacts = yaml |> get_artifacts_from_yaml
      # get all build commands
      build_cmd = yaml |> get_bld_cmd_from_yaml
      {:ok, build_cmd, artifacts}
    else
      Logger.error "yaml file: #{yaml_file} doesn't exist"
      {:error, [], []}
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

  defp copy_artifacts(src, artifacts_dir) do
    # This function copy artifacts files to artifacts_dir/build_id
    Logger.info "Copy build artifacts to artifacats directory"
    # TODO: refactoring, separate parse yaml and build beceause I need build_id here
    # Refactored build pipeline => start build in db => get yaml => run_cmd => store artifacts => complete build
    Logger.debug "Copy #{src} to #{artifacts_dir}"
    File.cp_r src, artifacts_dir
  end

  defp extract_cmd([]) do
    []
  end

  defp extract_cmd([head|tail]) do
    [{'exec', cmd}] = head
    cmd_str = cmd |> List.to_string
    [cmd] ++ extract_cmd(tail)
  end

end

defmodule EsioCiBuildFailed do
  defexception message: "Build Failed"
end