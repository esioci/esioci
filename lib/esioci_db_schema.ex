defmodule EsioCi.Build do
  use Ecto.Schema
  schema "builds" do
    field :state, :string
    field :artifacts_dir, :string, default: ""
    belongs_to :project, EsioCi.Project
    timestamps
  end
  
end

defmodule EsioCi.Project do
  use Ecto.Schema
  schema "projects" do
    field :name, :string
    has_many :builds, EsioCi.Build
    timestamps
  end
end