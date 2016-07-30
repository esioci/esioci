defmodule EsioCi.Router do
  use Plug.Router
  use Plug.ErrorHandler
  import Plug.Conn
  import Plug.Conn.Utils
  import Ecto.Query, only: [from: 2]
  require Logger

  plug Plug.Logger
  plug :match

  plug Plug.Static, at: "/artifacts", from: Application.get_env(:esioci, :artifacts_dir)
  plug Plug.Parsers, parsers: [:json],pass:  ["application/json"], json_decoder: Poison
  
  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug :match
  plug :dispatch

  # Root path
  get "/" do
    send_resp(conn, 200, "EsioCi app alpha")
  end

  # Run build for project using github webhook
  post "/api/v1/:project/bld/gh" do
    # Insert build to database
    q = from p in "projects",
      where: p.name == ^project,
      select: p.id

    p_id = EsioCi.Repo.all(q)
    Logger.debug p_id
    case Enum.count(p_id) do
       0 -> conn
            |> send_resp(404, "404: Project #{project} not found.")

       1 -> build_id = add_build_to_db(List.first(p_id))
            pid = spawn(EsioCi.Builder, :build, [])
            send pid, {self, conn, build_id, "gh"}
            conn
            |> send_resp(200, "Build created with id #{build_id}")

       _ -> conn
            |> send_resp(503, "Something get wrong...")
    end
  end

  # Get build with id or last build
  get "/api/v1/:project/bld/:b_id" do
    q = from p in "projects",
      where: p.name == ^project,
      select: p.id

    p_id = EsioCi.Repo.all(q)
    case Enum.count(p_id) do
      0 -> conn
           |> send_resp(404, "404: Project #{project} not found.")

      1 -> conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, Poison.encode!(EsioCi.Db.get_build_with_id(List.first(p_id), b_id)))

      _ -> conn
           |> send_resp(503, "Something get wrong...")
        
    end
  end


  # Get project by project name
  get "/api/v1/:project" do
    q = from p in "projects",
      where: p.name == ^project,
      select: p.id

    p_id = EsioCi.Repo.all(q)
    case Enum.count(p_id) do
      0 -> conn
           |> send_resp(404, "404: Project #{project} not found.")

      1 -> conn
            |> put_resp_content_type("application/json")
            |> send_resp(200, Poison.encode!(EsioCi.Db.get_project_by_id(List.first(p_id))))

      _ -> conn
           |> send_resp(503, "Something get wrong...")
        
    end
  end
  # 404
  match _ do
    conn
    |> send_resp(404, "404 Nothing here")
  end

  def add_build_to_db(project_id) do
    build = %EsioCi.Build{state: "CREATED", project_id: project_id}
    created_build = EsioCi.Repo.insert!(build)
    created_build.id
  end
end