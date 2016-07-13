defmodule EsioCi.Build do
  use Ecto.Schema
  schema "builds" do
    field :state, :string
    field :artifacts_dir, :string, default: ""
    timestamps
  end
  
end