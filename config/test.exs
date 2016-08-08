use Mix.Config

db = "esioci"
db_user = "postgres"
db_passwd = ""
db_host = "localhost"

if System.get_env("ESIOCI_TEST_DB") do
  db = System.get_env("ESIOCI_TEST_DB")
  db_user = System.get_env("ESIOCI_TEST_DB")
end
if System.get_env("ESIOCI_TEST_DB_PASSWD") do
  db_passwd = System.get_env("ESIOCI_TEST_DB_PASSWD")
end
if System.get_env("ESIOCI_TEST_DB_HOST") do
  db_host = System.get_env("ESIOCI_TEST_DB_HOST")
end

config :esioci, EsioCi.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: db,
  username: db_user,
  password: db_passwd,
  hostname: db_host
