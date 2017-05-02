defmodule EsioCi.TimeoutPoller do
  @moduledoc """
  This is a timeout poller module, runs every 5 minutes
  and stop all timeouted builds
  """
  use GenServer
  require Logger
  
  def start_link do
    GenServer.start_link(EsioCi.TimeoutPoller, %{}, [name: EsioCi.TimeoutPoller])
  end

  def init(state) do
    Logger.debug "Initialize timeout poller."
    Process.send_after(self, :poll, 300 * 1000)
    {:ok, state}
  end

  def handle_info(:poll, state) do
    Logger.debug "Run timeout poller."
    Process.send_after(self, :poll, 300 * 1000)
    {:noreply, state}
  end
end