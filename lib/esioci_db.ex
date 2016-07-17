defmodule Esioci.Db do
  import Logger
  import Ecto.Query, only: [from: 2]

  def get_build_with_id(p_id, b_id) do
    case b_id do
      "last" -> get_last_build_from_project(p_id)
       _ -> Logger.error "Not implemented yet"
            :nil
    end
  end 
  
  defp get_last_build_from_project(p_id) do
    Logger.info p_id
    q = from b in "builds",
      where: b.project_id == ^p_id,
      order_by: [desc: :id],
      limit: 1,
      select: [b.id, b.state, b.artifacts_dir, b.inserted_at, b.updated_at]

    EsioCi.Repo.all(q)
    
  end
end