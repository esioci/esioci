defmodule EsioCi.Common do
  @moduledoc """
  This is a EsioCi.Common module
  Place all common funcion here
  """
  require Logger

  @doc """
  This function runs shell command 'cmd' inside directory 'dir'

  ## parameters
  - cmd: String
  - dir: String
  """
  def run(cmd, dir, log_file \\ "build.log") do
    #TODO: Improve logging to file
    {:ok, file} = File.open "/tmp/#{log_file}", [:write]
    IO.binwrite file, "build started"
    Logger.info "Run #{cmd} in directory #{dir}"
    cmd_list = String.split(cmd)
    {stdout, exit_code} = System.cmd(hd(cmd_list), tl(cmd_list), stderr_to_stdout: true, cd: dir)
    if exit_code != 0 do
      Logger.error "Command #{cmd} exit code: #{exit_code}"
      Logger.error stdout
      #FIXME: Code duplicate
      IO.binwrite file, "Build cmd #{cmd} exited with error code #{exit_code}"
      IO.binwrite file, stdout
      File.close file
      raise "Command #{cmd} exit code: #{exit_code}"
      :error
    else
      Logger.info "Command #{cmd} exited successfully"
      Logger.info stdout
      #FIXME: Code duplicate
      IO.binwrite file, "Build cmd #{cmd} exited succesfully"
      IO.binwrite file, stdout
      File.close file
      :ok
    end
  end
  def change_bld_status(b_id, status) do
    build = EsioCi.Repo.get(EsioCi.Build, b_id)
    build = Ecto.Changeset.change build, state: status
    Logger.info "update"
    EsioCi.Repo.update! build
    
  end
end