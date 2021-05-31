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
    get("/help", PageController, :help)
    get("/terms", PageController, :terms)
    get("/privacy", PageController, :privacy)

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

  # Ajax
  scope "/ajax", FrontendWeb do
    pipe_through([:api])

    get("/relations", AjaxController, :relations)
    post("/relations", AjaxController, :relations)
    post("/save", AjaxController, :save)
  end

  scope "/auth", FrontendWeb do
    pipe_through([:browser])
    # should be #DELETE
    get("/logout", AuthController, :delete)
    get("/login", AuthController, :login)
    get("/signup", AuthController, :signup)
    post("/identity/callback", AuthController, :callback)
  end

  scope "/api", FrontendWeb do
    pipe_through(:api)

    post("/create", ApiController, :create)
    post("/update", ApiController, :update)
    get("/search", ApiController, :search)
    get("/item/:id", ApiController, :show)
  end
end
