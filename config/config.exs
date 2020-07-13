# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :api,
  ecto_repos: [Api.Repo],
  generators: [context_app: false]

# Configures the endpoint
config :api, Api.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vRuJFscBJw4MwuF1tlDx9UvwBqS3FHGV92QIdesrPMtGkYtoTsmtHFkYJKbX+v9c",
  render_errors: [view: Api.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Api.PubSub,
  live_view: [signing_salt: "QkHnyYRb"]

# Configure Mix tasks and generators
config :database,
  ecto_repos: [Database.Repo]

config :dlex, repo: Graph.Repo

config :auditor, repo: Database.Media.Change

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :frontend, FrontendWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FrontendWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Frontend.PubSub

# Via Authorizations app
config :ueberauth, Ueberauth,
  providers: [
    identity:
      {Ueberauth.Strategy.Identity,
       [
         callback_methods: ["POST"],
         uid_field: :username,
         nickname_field: :username,
         request_path: "/auth/new",
         callback_path: "/auth/identity/callback"
       ]}
  ]

# config :scrivener_html,
#   routes_helper: FrontendWeb.Router.Helpers,
#   # If you use a single view style everywhere, you can configure it here. See View Styles below for more info.
#   view_style: :bootstrap

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
