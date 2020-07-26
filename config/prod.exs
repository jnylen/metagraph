import Config

config :api, Api.Endpoint,
  http: [
    transport_options: [socket_opts: [:inet6]]
  ]
  cache_static_manifest: "priv/static/cache_manifest.json"

config :frontend, FrontendWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info
