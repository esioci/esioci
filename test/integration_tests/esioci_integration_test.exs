defmodule EsioCi.IntegrationTest do
  use ExUnit.Case
  use Plug.Test

  test "run github build" do
    conn = conn(:post, "/api/v1/default/bld/gh", "{\"esio\" : \"dsdds\"}")

    conn = EsioCi.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert Regex.match?(~r/^Build created with id \d+/, conn.resp_body)
    
  end
  
end