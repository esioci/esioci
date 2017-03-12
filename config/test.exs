use Mix.Config

config :esioci, EsioCi.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "esioci_test",
  username: "postgres",
  password: "",
  hostname: "localhost"