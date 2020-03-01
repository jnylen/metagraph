defmodule FrontendWeb.AuthController do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  use FrontendWeb, :controller
  plug(Ueberauth)
  plug(:put_layout, "auth.html")

  alias Ueberauth.Strategy.Helpers

  def login(conn, _params) do
    render(conn, "login.html", callback_url: Helpers.callback_url(conn, type: "login"))
  end

  def signup(conn, _params) do
    render(conn, "signup.html", callback_url: Helpers.callback_url(conn, type: "signup"))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"type" => "signup"}) do
    case Authorization.create(auth) do
      {:error, error} ->
        conn
        |> put_flash(:error, error)
        |> redirect(to: "/auth/signup")

      {:ok, user} ->
        # Maybe do email checkup
        conn
        |> put_flash(:info, "Successfully registred and logged in.")
        |> put_session(:current_user_id, user.id)
        |> redirect(to: "/")
    end
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"type" => "login"} = _params) do
    conn
    |> authenticated(Authorization.authenticate(auth))
  end

  defp authenticated(conn, {:ok, user}) do
    conn
    |> put_flash(:info, "Successfully authenticated.")
    |> put_session(:current_user_id, user.id)
    |> redirect(to: "/")
  end

  defp authenticated(conn, {:error, error}) do
    conn
    |> put_flash(:error, to_string(error))
    |> redirect(to: "/auth/login")
  end
end
