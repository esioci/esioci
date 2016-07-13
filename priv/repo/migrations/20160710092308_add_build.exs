defmodule EsioCi.Repo.Migrations.AddBuild do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :state, :string
      add :artifacts_dir, :string, default: ""
      timestamps
    end

  end
end
