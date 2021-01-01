defmodule Api.Custom.ItemController do
  @moduledoc """
  An endpoint for the bots to update data
  """

  use Api, :controller

  def update(conn, %{"uid" => uid, "values" => values}) do
    {:ok, item} = Graph.Repo.get_new(uid)
    changeset = item.__struct__.changeset(item, values)

    result =
      item
      |> Editor.update(
        changeset,
        conn.assigns.current_user
      )

    conn
    |> render("result.json", result: result)
  end

  def create(conn, %{"type" => type, "values" => values}) do
    changeset =
      get_module(type).changeset(
        get_module(type).__struct__,
        values
      )

    result =
      changeset
      |> Editor.create(conn.assigns.current_user)

    conn
    |> render("result.json", result: result)
  end

  defp get_module(name) do
    Graph.Repo.meta()
    |> Map.get(:lookup)
    |> Map.get(name)
  end
end
