defmodule Api.Router do
  use Api, :router

  pipeline :graphql do
    plug(Api.Authentication)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(Api.Authentication)
  end

  scope "/custom", Api.Custom do
    pipe_through(:api)

    post("/create", ItemController, :create)
    post("/update", ItemController, :update)
    get("/search", ItemController, :search)
  end

  scope "/" do
    pipe_through(:graphql)

    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: Api.Schema, interface: :playground)
    forward("/", Absinthe.Plug, schema: Api.Schema)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: Api.Telemetry)
    end
  end
end
