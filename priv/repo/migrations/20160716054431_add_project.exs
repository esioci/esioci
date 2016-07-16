defmodule EsioCi.Repo.Migrations.AddProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      timestamps
    end
  end
end
