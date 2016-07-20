defmodule Esioci.Db do
  import Logger
  import Ecto.Query, only: [from: 2]

  def get_build_with_id(p_id, b_id) do
    case b_id do
      "last" -> build = get_last_build_from_project(p_id) |> EsioCi.Repo.all |> EsioCi.Repo.preload(:project)
       _ -> Logger.error "Not implemented yet"
            :nil
    end
  end 
  
  defp get_last_build_from_project(p_id) do
    from builds in EsioCi.Build, where: builds.project_id == ^p_id, order_by: [desc: :id], limit: 1
  end
end