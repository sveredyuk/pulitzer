use Mix.Config

database_url = System.get_env("DATABASE_URL")

if database_url do
  config :pulitzer, Pulitzer.Repo,
    url: "#{database_url}_test",
    show_sensitive_data_on_connection_error: true,
    pool: Ecto.Adapters.SQL.Sandbox,
    ownership_timeout: 999_999_999
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
