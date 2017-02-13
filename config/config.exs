# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :fifty_two,
  ecto_repos: [FiftyTwo.Repo]

# Configures the endpoint
config :fifty_two, FiftyTwo.Endpoint,
  url: [host: "localhost"],
  force_ssl: System.get_env("FORCE_SSL") == "true",
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: FiftyTwo.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FiftyTwo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "FiftyTwo",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: System.get_env("SECRET_KEY_PASS"),
  serializer: FiftyTwo.Serializer.Guardian

config :canary,
  repo: FiftyTwo.Repo,
  current_user: :current_user,
  not_found_handler: {FiftyTwo.ControllerHelper, :handle_not_found},
  unauthorized_handler: {FiftyTwo.ControllerHelper, :handle_unauthorized}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
