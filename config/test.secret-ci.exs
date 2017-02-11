use Mix.Config

# Configure your database
config :fifty_two, FiftyTwo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "ubuntu",
  password: "",
  database: "circle_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
