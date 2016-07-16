defmodule Esioci.Router.Test do
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
end