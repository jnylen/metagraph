defmodule FrontendWeb.Plugs.CheckPermsForUser do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias FrontendWeb.Router.Helpers

  def init(params), do: params

  def call(conn, [perms: perms] = _params) do
    IO.inspect _params
    case check_lists(perms, conn.assigns.current_user.access) do
      false ->
        conn
        |> put_flash(:info, "You can't access that page")
        |> Phoenix.Controller.redirect(external: Helpers.page_url(FrontendWeb.Endpoint, :index))
        |> halt()
      true ->
        conn
    end
  end

  def call(conn, params) do
    conn
    |> put_flash(:info, "You can't access that page")
    |> Phoenix.Controller.redirect(external: Helpers.page_url(FrontendWeb.Endpoint, :index))
    |> halt()
  end

  @doc """
  Check if an list has any of the items in another list
  """
  defp check_lists(current_perms, needed_perms \\ []) do
    needed_perms
    |> Enum.map(&Enum.member?(current_perms, &1))
    |> Enum.member?(true)
  end
end
