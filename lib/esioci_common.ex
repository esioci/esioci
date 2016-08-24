defmodule EsioCi.Common do
  @moduledoc """
  This is a EsioCi.Common module
  Place all common funcion here
  """
  require Logger

  def run(cmd, dir \\ "/tmp") do
    if not File.exists?(dir) do
      Logger.debug "Direcory #{dir} doesn't exist, creating..."
      File.mkdir_p dir
    end
    cmd_list = String.split(cmd, " ")
    [cmd|args] = cmd_list
    try do
      Logger.debug "Run cmd: #{cmd} with args: #{args}"
      {stdout, exit_code} = System.cmd(cmd, args, stderr_to_stdout: true, cd: dir)
      Logger.warn stdout
      Logger.warn exit_code
      if exit_code != 0 do
        Logger.error stdout
        raise "Command #{cmd} exit code: #{exit_code}"
      else
        Logger.info stdout
        :ok
      end
    rescue
      e -> Logger.error inspect e
    end
  end

  def change_bld_status(b_id, status) do
    build = EsioCi.Repo.get(EsioCi.Build, b_id)
    build = Ecto.Changeset.change build, state: status
    Logger.info "Build status update to #{status}"
    EsioCi.Repo.update! build
    
  end
end