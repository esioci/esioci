defmodule EsioCi.Poller.Tests do
  use ExUnit.Case

  test "Test EsioCi.Poller" do
    EsioCi.Poller.handle_info(:poll, %{})
  end
end