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

  test 'get_artifacts_from_yaml test' do
    yaml = [{'build', [[{'exec', 'make esio'}]]}, {'artifacts', 'artifacts_file.txt'}]
    assert EsioCi.Builder.get_artifacts_from_yaml(yaml) == "artifacts_file.txt"
  end

  test 'test get_cmd_bld_from_yaml if has more than one exec' do
    yaml = [{'build', [[{'exec', 'one esio'}], [{'exec', 'two esios'}]]}]
    assert EsioCi.Builder.get_bld_cmd_from_yaml(yaml) == ['one esio', 'two esios']
  end

  test 'test parse yaml' do
    expect(EsioCi.Common, :run, fn(cmd, dir) -> :ok end)
    assert EsioCi.Builder.parse_yaml({:ok, Path.absname("test/test_yaml_ok")}) == {:ok, ['mix deps.get && mix.compile'], nil}
  end

  test 'test parse yaml with more than one exec' do
    expect(EsioCi.Common, :run, fn(cmd, dir) -> :ok end)
    assert EsioCi.Builder.parse_yaml({:ok, Path.absname("test/test_yaml_two_execs")}) == {:ok, ['mix deps.get', 'mix.compile'], nil}
  end

  test 'test parse yaml with artifacts' do
    expect(EsioCi.Common, :run, fn(cmd, dir) -> :ok end)
    assert EsioCi.Builder.parse_yaml({:ok, Path.absname("test/test_yaml_artifacts")}) == {:ok, ['mix deps.get && mix.compile'], "test_file"}
  end

  test 'test parse broken yaml' do
    expect(EsioCi.Common, :run, fn(cmd, dir) -> :ok end)
    assert_raise MatchError, fn -> EsioCi.Builder.parse_yaml({:ok, Path.absname("test/test_yaml_broken")}) end
  end
  
  test 'test parse nonexisting yaml' do
    expect(EsioCi.Common, :run, fn(cmd, dir) -> :ok end)
    assert EsioCi.Builder.parse_yaml({:ok, Path.absname("test/no_yaml")}) == {:error, [], []}
  end
end

defmodule EsioCi.Builder.Tests.NoMeck do
  # tests EsioCi.Builder class without meck
  use ExUnit.Case

  @test_dir "/tmp/test_esioci_builder_test_nomeck"

  setup do
    File.rm_rf @test_dir
    on_exit fn -> File.rm_rf @test_dir end
    :ok
  end

  test 'test clone repository' do
    EsioCi.Builder.clone({:ok, "git://github.com/esioci/esioci", "esioci/esioci", "fake", @test_dir})
  end
end