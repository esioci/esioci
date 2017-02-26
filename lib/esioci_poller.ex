defmodule EsioCi.Poller do
  @moduledoc """
  This is a poller module, runs every minute
  and check if any changes in project repository.
  If yes runs build.
  """
  use GenServer
  require Logger
  
  def start_link do
    GenServer.start_link(EsioCi.Poller, %{})
  end

  def init(state) do
    Process.send_after(self, :poll, 6000)
    {:ok, state}
  end

  def handle_info(:poll, state) do
    Process.send_after(self, :poll, 6000)
    Logger.debug "Run poller"
    {:noreply, state}
  end

end