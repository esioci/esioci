defmodule EsioCi.Mixfile do
  use Mix.Project

  def project do
    [app:               :esioci,
     version:           "0.5.0",
     elixir:            "~> 1.4",
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
      applications: [:logger, :cowboy, :plug, :yamerl, :postgrex, :ecto, :redix]
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
      {:plug, "~> 1.3.0"},
      {:cors_plug, "~> 1.1"},
      {:poison, "~> 3.0"},
      {:ecto, "~> 2.1"},
      {:postgrex, ">= 0.0.0"},
      {:yamerl, "~> 0.4.0"},
      {:ex_doc, "~> 0.12", only: :dev},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:excoveralls, "~> 0.5", only: :test},
      {:meck, "~> 0.8.2", only: :test},
      {:logger_file_backend, "~> 0.0.8"},
      {:gitex, "~> 0.2.0"},
      {:redix, ">= 0.0.0"}
    ]
  end
end
