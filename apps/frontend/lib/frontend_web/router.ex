defmodule FrontendWeb.Router do
  use FrontendWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {FrontendWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(FrontendWeb.Plugs.SetCurrentUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(:protect_from_forgery)
    plug(FrontendWeb.Plugs.SetCurrentUser)
  end

  scope "/", FrontendWeb do
    pipe_through(:browser)

    # Root
    get("/", PageController, :index)

    # Profile
    get("/profile", PageController, :profile)
    put("/profile", PageController, :update)

    # Item new
    live("/new", ItemLive, :new)
    live("/new/:chosen_type", ItemLive, :new_item)

    # Changes
    get("/feed", FeedController, :index)

    # Browse types
    live("/browse", BrowseLive, :index)
    live("/browse/:type", BrowseLive.Show, :show)
    live("/browse/:type/:menu", BrowseLive.Show, :show)

    # Item view
    live("/uid/:uid", ItemLive, :show)
    live("/uid/:uid/changes", ItemLive, :changes)
    live("/uid/:uid/edit", ItemLive, :edit)

    # Query
    get("/query", QueryController, :index)
  end

  scope "/auth", FrontendWeb do
    pipe_through([:browser])
    # should be #DELETE
    get("/logout", AuthController, :delete)
    get("/login", AuthController, :login)
    get("/signup", AuthController, :signup)
    post("/identity/callback", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  scope "/", FrontendWeb do
    pipe_through :api

    post("/query", QueryController, :query)
  end
end
