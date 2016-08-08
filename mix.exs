defmodule EsioCi.Mixfile do
  use Mix.Project

  def project do
    [app:               :esioci,
     version:           "0.1.0",
     elixir:            "~> 1.2",
     build_embedded:    Mix.env == :prod,
     start_permanent:   Mix.env == :prod,
     deps:              deps(),
     test_coverage:     [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {EsioCi, []}, 
      applications: [:logger, :cowboy, :plug, :yamerl, :postgrex, :ecto]
    ]
  end


  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.1.6"},
      {:cors_plug, "~> 1.1"},
      {:poison, "~> 2.2"},
      {:ecto, "~> 2.0.1"},
      {:postgrex, ">= 0.0.0"},
      {:yamerl, github: "yakaz/yamerl"},
      {:ex_doc, "~> 0.12", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:excoveralls, "~> 0.5", only: :test},
      {:meck, "~> 0.8.2", only: :test}
    ]
  end
end
