defmodule EsioCi.Poller do
  @moduledoc """
  This is a poller module, runs every minute
  and check if any changes in project repository.
  If yes runs build.
  """
  use GenServer
  require Logger
  
  def start_link do
    GenServer.start_link(EsioCi.Poller, %{}, [name: EsioCi.Poller])
  end

  def init(state) do
    poller_interval = Application.get_env(:esioci, :poller_interval, 60 * 1000)
    Logger.debug "Poller interval: #{poller_interval}"

    Process.send_after(self, :poll, poller_interval)
    {:ok, state}
  end

  def handle_info(:poll, state) do
    projects = EsioCi.Db.get_project_by_id("all")
    Logger.debug "Run poller"

    poller_interval = Application.get_env(:esioci, :poller_interval, 60 * 1000)
    Logger.debug "Poller interval: #{poller_interval}"
    pid = spawn(EsioCi.Builder, :poller_build, [])
    send pid, {self, "default"}

    Process.send_after(self, :poll, poller_interval)
    {:noreply, state}
  end

  defp pull_repository do
  # check if repository has changes since last build

  end
end