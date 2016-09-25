defmodule EsioCi.Buildlog.Test do
  use ExUnit.Case

  @log_file "/tmp/log_test.log"

  setup do
    #File.rm_rf @log_file
    #on_exit fn -> File.rm @log_file end
    :ok
  end

  test "write log to file" do
    assert EsioCi.Buildlog.log("ERROR", "test log", @log_file) == :ok
    {:ok, text} = File.read @log_file
    assert Regex.match?(~r/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}Z - ERROR - test log/, text)
  end
  
end