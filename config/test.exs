use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fifty_two, FiftyTwo.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure Comeonin
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure JUnitFormatter
config :junit_formatter,
  report_file: "results.xml",
  print_report_file: true

# Import the config/test.secret.exs which is used for
# specifying credentials.
import_config "test.secret.exs"
