import Config

# Configure your database
config :database, Database.Repo,
  adapter: Ecto.Adapters.Postgres,
  host: "localhost",
  port: 5432,
  username: "metagraph",
  password: "metagraph",
  database: "metagraph"

config :authorization, Authorization.Guardian,
  # optional
  allowed_algos: ["HS512"],
  # optional
  verify_module: Guardian.JWT,
  issuer: "Metagraph",
  ttl: {30, :days},
  allowed_drift: 2000,
  # optional
  verify_issuer: true,
  # generated using: JOSE.JWK.generate_key({:oct, 16}) |> JOSE.JWK.to_map |> elem(1)
  secret_key: %{"k" => "4Cg2QCFvSq5Xuh47mYCiEw", "kty" => "oct"},
  serializer: Authorization.Guardian

# Watch static and templates for browser reloading.

config :frontend, FrontendWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  secret_key_base: "8GRJk6d3CycYP8xk8Wde3xLbBhqr6eGUut7v/nrC6hD2+tHEP5rOVXi8m1nPWRJX",
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../apps/frontend/assets", __DIR__)
    ]
  ]

config :frontend, FrontendWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/frontend_web/views/.*(ex)$},
      ~r{lib/frontend_web/templates/.*(eex)$},
      ~r{lib/frontend_web/live/.*(ex)$}
    ]
  ],
  live_view: [
    signing_salt: "SECRET_SALT"
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
