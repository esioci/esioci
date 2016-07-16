defmodule Seeds do
  def create_default_project do
    project = %EsioCi.Project{name: "default"}
    EsioCi.Repo.insert!(project)
  end
  
end

Seeds.create_default_project