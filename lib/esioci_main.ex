defmodule EsioCi.Main do
  def start_link(name) do
    { :ok, _ } = Plug.Adapters.Cowboy.http EsioCi.Router, []
  end
end
