defmodule EsioCi.Builder.Tests do
  use ExUnit.Case
  import :meck

  setup_all do
    new(EsioCi.Common)
    on_exit fn -> unload end
    :ok
  end

  test 'get_cmd_bld_from_yaml test' do
    yaml = [{'build', [[{'exec', 'make esio'}]]}]
    assert EsioCi.Builder.get_bld_cmd_from_yaml(yaml) == ['make esio']
  end

  test 'test get_cmd_bld_from_yaml if has more than one exec' do
    yaml = [{'build', [[{'exec', 'one esio'}], [{'exec', 'two esios'}]]}]
    assert EsioCi.Builder.get_bld_cmd_from_yaml(yaml) == ['one esio', 'two esios']
  end

  test 'test parse yaml' do
    expect(EsioCi.Common, :run, fn(cmd, dir) -> :ok end)
    assert EsioCi.Builder.parse_yaml({:ok, Path.absname("test/test_yaml_ok")}) == [:ok]
  end

  test 'test parse yaml with more than one exec' do
    expect(EsioCi.Common, :run, fn(cmd, dir) -> :ok end)
    assert EsioCi.Builder.parse_yaml({:ok, Path.absname("test/test_yaml_two_execs")}) == [:ok, :ok]
  end

  test 'test parse broken yaml' do
    expect(EsioCi.Common, :run, fn(cmd, dir) -> :ok end)
    assert_raise MatchError, fn -> EsioCi.Builder.parse_yaml({:ok, Path.absname("test/test_yaml_broken")}) end
  end
  
end