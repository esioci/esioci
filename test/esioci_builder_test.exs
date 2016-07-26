defmodule EsioCi.Builder.Tests do
  use ExUnit.Case, async: true

  test 'get_cmd_bld_from_yaml test' do
    yaml = [{'build', [[{'exec', 'make esio'}]]}]
    assert EsioCi.Builder.get_bld_cmd_from_yaml(yaml) == "make esio"
  end
  
end