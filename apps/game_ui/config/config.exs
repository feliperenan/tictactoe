# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :game_ui, GameUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iSgt9Ix3IycYEy8B0DCOQpJLZpUsC4spNQiVXSnYllu8VYy6V8fDuqEAy1U4uCXS",
  render_errors: [view: GameUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GameUi.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "ruPl32nOr7f0JYZb5dDSlLPgiX8/q3P/oVre0GMTLvAtLLvpd+XzVKDLzHWRqWn+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
