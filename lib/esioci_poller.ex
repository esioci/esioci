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

    #Process.send_after(self, :poll, poller_interval)
    {:ok, state}
  end

  def handle_info(:poll, state) do
    Logger.debug "Run poller"
    projects = EsioCi.Db.get_project_by_id("all")

    {:ok} = poller_iterator projects
    pid = spawn(EsioCi.Builder, :poller_build, [])
    send pid, {self, "default"}

    # pull_repository

    poller_interval = Application.get_env(:esioci, :poller_interval, 60 * 1000)
    Logger.debug "Poller interval: #{poller_interval}"
    Process.send_after(self, :poll, poller_interval)
    {:noreply, state}
  end

  def poller_iterator(projects) do
  # Iterate over projects list and run repo checker
    case projects do
      [] -> {:ok}
       _ -> [head | tail] = projects
            {:ok, repo} = Map.fetch(head, :repository)
            {:ok, name} = Map.fetch(head, :name)
            Logger.debug "Check project: #{name} repository with address: #{repo}"
            if repo != "None", do: check_poll(name, repo)
            poller_iterator(tail)
    end
  end

  def check_poll(name, repo) do
    # download repository and get revision sha
    # if revision doesn't exist in redis, run build immidiatelly
    # othervise check if revision has been changed, if yes run build
    {:ok, dst_dir} = EsioCi.Builder.clone {:ok, repo, name, nil, nil}
    r = Gitex.Git.open(dst_dir)
    {:ok, rev} = Gitex.get(:head, r) |> Map.fetch(:hash)
    Logger.debug "Current revision: #{rev}"
    {:ok, conn} = Redix.start_link
    case Redix.command(conn, ~w(GET #{name})) do
       {:ok, nil }   -> run_poller_build(name)
       {:ok, db_rev} -> if rev != db_rev, do: run_poller_build(name)
    end
    Redix.command(conn, ~w(SET #{name} #{rev}))
    {:ok}
  end

  def run_poller_build(name) do
    pid = spawn(EsioCi.Builder, :poller_build, [])
    send pid, {self, name}
  end

  def pull_repository do
  # check if repository has changes since last build
    {:ok, conn} = Redix.start_link
    case Redix.command(conn, ~w(GET project_sha)) do
       {:ok, nil } -> Logger.info "ESIO"
       {:ok, x} -> Logger.info x
    end
  end
end