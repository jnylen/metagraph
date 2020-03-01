defmodule AdminWeb.PageController do
  use AdminWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
