defmodule EsioCi.Db.Tests do
  use ExUnit.Case

  test 'test get project by name' do
    assert EsioCi.Db.get_project_by_name("default") == {:ok, 1}
  end

  test "add build to DB and change status" do
    { :ok, b_id } = EsioCi.Db.add_build_to_db(1)
    build = EsioCi.Repo.get(EsioCi.Build, b_id)
    assert build != nil
  end
end

