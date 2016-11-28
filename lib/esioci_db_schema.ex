defmodule EsioCi.Build do
  @moduledoc """
  Schema for "builds" table.
  """
  use Ecto.Schema
  @derive {Poison.Encoder, only: [:id, :state, :artifacts_dir, :project, :inserted_at, :updated_at]}
  schema "builds" do
    field :state, :string
    field :artifacts_dir, :string, default: ""
    belongs_to :project, EsioCi.Project
    timestamps
  end
  
end

defmodule EsioCi.Project do
  @moduledoc """
  Schema for "projects" table.
  """
  use Ecto.Schema
  @derive {Poison.Encoder, only: [:id, :name]}
  schema "projects" do
    field :name, :string
    has_many :builds, EsioCi.Build, on_delete: :delete_all
    timestamps
  end
end