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
    plug(FrontendWeb.Plugs.SetCurrentUser)
  end

  scope "/", FrontendWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/help", PageController, :help)
    get("/profile", PageController, :profile)
    put("/profile", PageController, :update)

    # get("/new", ItemController, :new)
    live("/new", ItemLive, :new)
    live("/new/:chosen_type", ItemLive, :new_item)

    # post("/new", ItemController, :create)
    get("/feed", FeedController, :index)

    # get("/browse", ItemController, :index)
    # get("/browse/:type", ItemController, :list)

    live("/browse", BrowseLive, :index)
    live("/browse/:type", BrowseLive.Show, :show)
    live("/browse/:type/:menu", BrowseLive.Show, :show)

    live("/uid/:uid", ItemLive, :show)
    live("/uid/:uid/changes", ItemLive, :changes)
    live("/uid/:uid/edit", ItemLive, :edit)

    # get("/uid/:uid", ItemController, :show)
    # get("/uid/:uid/edit", ItemController, :edit)
    # post("/uid/:uid/update", ItemController, :update)
    # get("/uid/:uid/changes", ItemController, :changes)
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
  # scope "/api", FrontendWeb do
  #   pipe_through :api
  # end
end
