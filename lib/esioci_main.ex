defmodule EsioCi.Main do
  @moduledoc false
  def start_link(name) do
    {:ok, _} = Plug.Adapters.Cowboy.http EsioCi.Router, [], [port: Application.get_env(:esioci, :api_port, 4000)]
  end
end
