use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fifty_two, FiftyTwo.Web.Endpoint,
  http: [port: 4001],
  server: false

config :fifty_two, FiftyTwo.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: System.get_env("DATABASE_SSL") == "true"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure Comeonin
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure JUnitFormatter
config :junit_formatter,
  report_file: "results.xml",
  print_report_file: true
