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
    Logger.debug "Run poller"
    projects = EsioCi.Db.get_project_by_id("all")

    poller_iterator(projects)
    pid = spawn(EsioCi.Builder, :poller_build, [])
    send pid, {self, "default"}

    pull_repository

    poller_interval = Application.get_env(:esioci, :poller_interval, 60 * 1000)
    Logger.debug "Poller interval: #{poller_interval}"
    Process.send_after(self, :poll, poller_interval)
    {:noreply, state}
  end

  def poller_iterator(projects) do
  # Iterate over projects list and run repo checker
    [ head | tail ] = projects
    { :ok, repo } = Map.fetch(head, :repository)
    { :ok, name } = Map.fetch(head, :name)
    if repo != "None", do: check_poll(name, repo)
  end

  defp check_poll(name, repo) do
    :ok = EsioCi.Builder.clone {:ok, repo, name, nil, nil}
  end

  defp pull_repository do
  # check if repository has changes since last build
    { :ok, conn } = Redix.start_link
    { :ok, sha } = Redix.command(conn, ~w(GET project_sha))
    IO.puts inspect sha

  end
end