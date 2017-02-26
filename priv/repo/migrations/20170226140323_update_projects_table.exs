defmodule EsioCi.Repo.Migrations.UpdateProjectsTable do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :repository, :string, default: "None"
    end

  end
end
