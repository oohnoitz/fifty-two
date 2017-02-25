use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :fifty_two, FiftyTwo.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [
    scheme: System.get_env("URL_SCHEME") || "http",
    host: System.get_env("URL_HOST"),
    port: String.to_integer(System.get_env("URL_PORT") || "80")
  ],
  cache_static_manifest: "priv/static/manifest.json"

# Do not print debug messages in production
config :logger, level: :info

# Database
config :fifty_two, FiftyTwo.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: System.get_env("DATABASE_SSL") == "true"
