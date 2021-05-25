import Config

# Do not print debug messages in production
config :logger, level: :info

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :database, Database.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE", "100"))

config :frontend, Frontend.Endpoint,
  url: [host: System.get_env("APP_HOST", "localhost")],
  http: [
    ip: {0, 0, 0, 0},
    port: {:system, "DOKKU_PROXY_PORT"},
    compress: true
  ],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: secret_key_base,
  check_origin: false
