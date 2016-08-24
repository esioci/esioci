# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :esioci, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:esioci, :key)
#
# Or configure a 3rd-party app:
#
config :logger,
  level: :debug,
  backends: [{LoggerFileBackend, :debug_log},
             :console]

# loging to file configuration
config :logger, :debug_log,
  path: "debug.log",                  # log file name
  level: :debug                       # log level :debug, :error, :info, :warn

# database configuration
config :esioci, EsioCi.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "esioci",
  username: "postgres",
  password: "",
  hostname: "localhost"

config :esioci, ecto_repos: [EsioCi.Repo]

# application configuration
config :esioci,
  api_port: 4000,                     # application backend port - configure this as source port in esioci-ui
  artifacts_dir: "/tmp/artifacts"     # top artifacts dir, all artifacts will be placed under this path

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
import_config "#{Mix.env}.exs"
