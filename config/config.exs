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

db = if System.get_env("ESIOCI_DB"), do: System.get_env("ESIOCI_DB"), else: "esioci"
db_user = if System.get_env("ESIOCI_DB_USER"), do: System.get_env("ESIOCI_DB_USER"), else: "postgres"
db_passwd = if System.get_env("ESIOCI_DB_PASSWD"), do: System.get_env("ESIOCI_DB_PASSWD"), else: ""
db_host = if System.get_env("ESIOCI_DB_HOST"), do: System.get_env("ESIOCI_DB_HOST"), else: "localhost"
{ api_port, _ } = ( if System.get_env("ESIOCI_API_PORT"), do: System.get_env("ESIOCI_API_PORT"), else: "4000" ) |> Integer.parse

# database configuration
config :esioci, EsioCi.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "#{db}",
  username: "#{db_user}",
  password: "#{db_passwd}",
  hostname: "#{db_host}"

config :esioci, ecto_repos: [EsioCi.Repo]

# application configuration
config :esioci,
  api_port: api_port,                     # application backend port - configure this as source port in esioci-ui
  artifacts_dir: "/tmp/artifacts"     # top artifacts dir, all artifacts will be placed under this path

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
import_config "#{Mix.env}.exs"
