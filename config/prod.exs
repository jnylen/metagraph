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
  live_view: [signing_salt: System.get_env("LIVE_VIEW_SALT")],
  url: [host: System.get_env("APP_HOST", "localhost")],
  http: [
    ip: {0, 0, 0, 0},
    port: System.get_env("WEB_PORT",
    compress: true
  ],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: secret_key_base,
  check_origin: false

config :meilisearch,
  endpoint: System.get_env("MEILI_URL"),
  api_key: System.get_env("MEILI_API_KEY")

config :authorization, Authorization.Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Metagraph",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: %{"k" => System.get_env("GUARDIAN_SECRET_KEY"), "kty" => "oct"},
  serializer: Authorization.Guardian

config :dlex, Graph.Repo,
  hostname: System.get_env("GRAPH_HOST"),
  port: String.to_integer(System.get_env("GRAPH_PORT", "9080"))
