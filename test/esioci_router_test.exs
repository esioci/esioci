defmodule Esioci.Router.Test do
  import Ecto.Query, only: [from: 2]
  use ExUnit.Case, async: true
  use Plug.Test

  @opts EsioCi.Router.init([])

  test "returns hello world" do
    conn = conn(:get, "/")

    conn = EsioCi.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "EsioCi app alpha"
  end

  test "can't create build for nonexisting project" do
    conn = conn(:post, "/api/v1/esiononexistingproject/bld")

    conn = EsioCi.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "404: Project esiononexistingproject not found."
  end

  test "returns 404" do
    conn = conn(:get, "/esioesioesio")

    conn = EsioCi.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "add build to db and change status" do
    b_id = EsioCi.Router.add_build_to_db(1)
    build = EsioCi.Repo.get(EsioCi.Build, b_id)
    assert build != nil

    EsioCi.Common.change_bld_status(b_id, "esioesioesio")
    build = EsioCi.Repo.get(EsioCi.Build, b_id)
    assert build.state == "esioesioesio"
  end
end