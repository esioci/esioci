defmodule EsioCi.Buildlog.Test do
  use ExUnit.Case

  test "write log to file" do
    assert EsioCi.Buildlog.log("ERROR", "test log", "/tmp/log_test.log") == :ok
  end
  
end