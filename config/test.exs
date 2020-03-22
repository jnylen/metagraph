import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api, Api.Endpoint,
  http: [port: 4002],
  server: false

# Configure your database
config :database, Database.Repo,
  username: "postgres",
  password: "postgres",
  database: "database_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :frontend, FrontendWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
