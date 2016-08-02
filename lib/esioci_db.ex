defmodule EsioCi.Db do
  import Logger
  import Ecto.Query, only: [from: 2]

  def get_build_with_id(p_id, b_id) do
    # case b_id do
    #   "last" -> build = get_last_build_from_project(p_id) |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
    #    b_id  -> build = get_build(p_id, b_id) |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
    #    _ -> Logger.error "DUPA"
    # end
    cond do
      b_id == "last"                -> build = get_last_build_from_project(p_id) |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
      b_id == "all"                 -> build = get_builds(p_id) |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
      Integer.parse(b_id) != :error -> build = get_build(p_id, b_id) |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
      true                          -> :error
    end
  end

  def get_project_by_id(p_id) do
    get_project(p_id) |> EsioCi.Repo.all |> EsioCi.Repo.preload(:builds)
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
end