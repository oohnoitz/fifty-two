use Mix.Config

# Configure your database
config :fifty_two, FiftyTwo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "fifty_two_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
