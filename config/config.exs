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
  secret_key_base: "3glIkswhLn2QDLr4L0vnU7yUjiDQuRmgGkLUmS6S6n1ewyhpbTl1vXrVszuMpCE+",
  render_errors: [view: FiftyTwo.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FiftyTwo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
