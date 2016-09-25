defmodule EsioCi.Common do
  @moduledoc """
  This is a EsioCi.Common module
  Place all common funcion here
  """
  require Logger

  def run(cmd, dir \\ "/tmp", log_file \\ nil) do
    if not File.exists?(dir) do
      Logger.debug "Direcory #{dir} doesn't exist, creating..."
      File.mkdir_p dir
    end
    cmd_list = String.split(cmd, " ")
    [cmd|args] = cmd_list
    try do

      log = "Run cmd: #{cmd} with args: #{args}"
      Logger.debug log
      if log_file, do: EsioCi.Buildlog.log "INFO", log, log_file

      {stdout, exit_code} = System.cmd(cmd, args, stderr_to_stdout: true, cd: dir)
      Logger.debug stdout
      if log_file, do: EsioCi.Buildlog.log "INFO", stdout, log_file
      Logger.debug exit_code
      if exit_code != 0 do
        log = "Command #{cmd} exit code: #{exit_code}"
        if log_file, do: EsioCi.Buildlog.log "ERROR", log, log_file
        Logger.error log
        :error
      else
        :ok
      end
    rescue
      e -> Logger.error inspect e
           :error
    end
  end

  def change_bld_status(b_id, status) do
    build = EsioCi.Repo.get(EsioCi.Build, b_id)
    build = Ecto.Changeset.change build, state: status
    Logger.info "Build status update to #{status}"
    EsioCi.Repo.update! build
    
  end
end