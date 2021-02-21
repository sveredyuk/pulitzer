use Mix.Config

if System.get_env("GITHUB_ACTIONS") do
  config :elixirius, Elixirius.Repo,
    username: "postgres",
    password: "postgres"
else
  config :pulitzer, Pulitzer.Repo,
  database: "pulitzer_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 999_999_999
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pulitzer, PulitzerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
