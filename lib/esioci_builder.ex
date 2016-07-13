defmodule EsioCi.Builder do
  require Logger

  def build do
    receive do
      {sender, msg, build_id} ->
        try do
          Logger.debug "Processing build with id: #{build_id}"
          :random.seed(:os.timestamp()) 
          dst = "/tmp/build/#{:random.uniform(666)}"
          Logger.debug "Create directory #{dst}"
          File.mkdir_p(dst)
          Logger.debug "Receive message from #{inspect sender}"

          {scm, repo_address} = parse_bitbucket(msg)

          download_sources(scm, repo_address, dst)

          run_build(dst)
        rescue
          e in RuntimeError -> e
          #Logger.error "Exception!"
        end

    end
  end

  defp download_sources(scm, repo_address, dst) do
    case scm do
       "git" -> clone_git(repo_address, dst)
       _ -> clone_git(repo_address, dst)
        
    end
  end

  defp clone_git(repo_address, dst) do
    cmd = "git clone #{repo_address} #{dst}"
    Logger.info "Cloning git repository #{repo_address} to #{dst}"
    EsioCi.Common.run(cmd, dst)
  end

  defp run_build(dst) do
    Logger.info "Run build"
    cmd = get_exec_from_yaml(dst)
    EsioCi.Common.run(cmd, dst)
  end

  defp get_exec_from_yaml(dst) do
    Logger.info "Parse build.yaml file"
    [yaml | _] = :yamerl_constr.file("#{dst}/esioci.yaml")
    [build | _] = :proplists.get_value('build', yaml)
    :proplists.get_value('exec', build) |> List.to_string

  end
  defp parse_bitbucket(req_json) do
    scm = req_json.params["repository"]["scm"]
    Logger.debug "Repository scm type: #{scm}"

    repo_address = "git@bitbucket.org:#{req_json.params["repository"]["full_name"]}.git"

    Logger.debug "Repository address: #{repo_address}"

    {scm, repo_address}
  end
end
