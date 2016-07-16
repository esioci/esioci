defmodule EsioCi.Router do
  use Plug.Router
  use Plug.ErrorHandler
  import Plug.Conn
  import Plug.Conn.Utils
  require Logger

  plug Plug.Logger
  plug :match


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

  get "/api/v1/:project/bld" do
    # Insert build to database
    Logger.info project
    #build = %EsioCi.Build{state: "CREATED"}
    #created_build = EsioCi.Repo.insert!(build)
    #build_id = created_build.id

    #pid = spawn(EsioCi.Builder, :build, [])
    #send pid, {self, conn, build_id}

    conn
    |> send_resp(200, "Build created")
  end

  # deprecated
  post "/api/v1/bld" do
    # Insert build to database
    build = %EsioCi.Build{state: "CREATED"}
    created_build = EsioCi.Repo.insert!(build)
    build_id = created_build.id

    pid = spawn(EsioCi.Builder, :build, [])
    send pid, {self, conn, build_id}

    conn
    |> send_resp(200, "Build created")
  end

  # 404
  match _ do
    conn
    |> send_resp(404, "404 Nothing here")
  end
end