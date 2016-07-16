defmodule EsioCi.Repo.Migrations.AddProjectToBuild do
  use Ecto.Migration

  def change do
    alter table(:builds) do
      add :project_id, references(:projects)
    end
  end
end
