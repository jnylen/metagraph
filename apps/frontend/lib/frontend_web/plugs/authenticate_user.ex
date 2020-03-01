defmodule FrontendWeb.Plugs.AuthenicateUser do
  import Plug.Conn
  alias FrontendWeb.Router.Helpers

  def init(_params) do
  end

  def call(conn, params) do
    IO.inspect params

    if conn.assigns.user_signed_in? do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(external: Helpers.auth_url(FrontendWeb.Endpoint, :login))
      |> halt()
    end
  end
end
