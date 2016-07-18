defmodule Esioci.Db.Test do
  import Ecto.Query, only: [from: 2]
  import Logger
  use ExUnit.Case, async: true

  test "return last build status" do
    build = %EsioCi.Build{state: "CREATED-esio-last-build-status", project_id: 1}
    created_build = EsioCi.Repo.insert!(build)
    {_, inserted_at} = Ecto.DateTime.dump(created_build.inserted_at)
    {_, updated_at} = Ecto.DateTime.dump(created_build.updated_at)
    assert Esioci.Db.get_build_with_id(1, "last") == [[created_build.id,
            "CREATED-esio-last-build-status", "",
            inserted_at,
            updated_at]]
  end
end
