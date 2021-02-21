use Mix.Config

config :pulitzer,
  ecto_repos: [Pulitzer.Repo]

# Configures the endpoint
config :pulitzer, PulitzerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2SuS4R4xhkzjvPh1GtNW3HDZni+SJhQ6MJMefFWGNRhJcdt2ajYSH+Ruc3xIyQBI",
  render_errors: [view: PulitzerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Pulitzer.PubSub,
  live_view: [signing_salt: "Rzv3k2dX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
