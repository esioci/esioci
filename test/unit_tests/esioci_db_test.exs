defmodule EsioCi.Db.Tests do
  use ExUnit.Case

  test 'test get project by name' do
    assert EsioCi.Db.get_project_by_name("default") == 1
  end
end

