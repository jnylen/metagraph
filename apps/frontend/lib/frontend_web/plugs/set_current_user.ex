defmodule FrontendWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    conn
    |> set_assigns(user_id)
  end

  def set_assigns(conn, user_id) do
    user = Database.get_user(user_id)

    cond do
      current_user = user && user ->
        conn
        |> assign(:current_user, current_user)
        |> assign(:user_signed_in?, true)

      true ->
        conn
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)
    end
  end
end
