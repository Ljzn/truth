# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :veritas, VeritasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Fsczy+20G+Q5ov77yXi9N3Bzl0iUVPBZjdawOjijZlF8FDkPEvLUTE2IJfZ1ULIA",
  render_errors: [view: VeritasWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Veritas.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "WN0ED2dBDMEHGZsj+b14I0xMYZe67k7o"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
