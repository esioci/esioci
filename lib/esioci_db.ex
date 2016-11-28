defmodule EsioCi.Db do
  @moduledoc """
  EsioCi.Db module is responsible for any manipultion on database,
  e.g. get from database, save to db. All operations on db should be placed here.
  """
  import Logger
  import Ecto.Query, only: [from: 2]

  def get_build_with_id(p_id, b_id) do
    cond do
      b_id == "last"                -> p_id |> get_last_build_from_project |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
      b_id == "all"                 -> p_id |> get_builds |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
      Integer.parse(b_id) != :error -> get_build(p_id, b_id) |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
      true                          -> :error
    end
  end

  def get_project_by_id(p_id) do
    Logger.info p_id
    cond do
      p_id == "all"                 -> get_projects |> EsioCi.Repo.all |> EsioCi.Repo.preload(:builds)
      Integer.parse(p_id) != :error -> p_id |> get_project |> EsioCi.Repo.all |> EsioCi.Repo.preload(:builds)
      true                          -> :error
    end
  end
  
  defp get_last_build_from_project(p_id) do
    from builds in EsioCi.Build, where: builds.project_id == ^p_id, order_by: [desc: :id], limit: 1
  end

  defp get_build(p_id, b_id) do
    from builds in EsioCi.Build, where: builds.project_id == ^p_id and builds.id == ^b_id, order_by: [desc: :id]
  end

  defp get_builds(p_id) do
    from builds in EsioCi.Build, where: builds.project_id == ^p_id, order_by: [desc: :id]
  end

  defp get_project(p_id) do
    from projects in EsioCi.Project, where: projects.id == ^p_id, order_by: [desc: :id]
  end

  defp get_projects do
    from projects in EsioCi.Project, order_by: [desc: :id]
  end
end