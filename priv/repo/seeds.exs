defmodule Seeds do
  def create_default_project do
    project = %EsioCi.Project{name: "default"}
    EsioCi.Repo.insert!(project)
    project = %EsioCi.Project{name: "esioci", repository: "https://github.com/esioci/esioci.git"}
    EsioCi.Repo.insert!(project)
  end
  
end

Seeds.create_default_project
