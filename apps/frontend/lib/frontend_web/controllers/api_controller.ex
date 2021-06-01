defmodule FrontendWeb.ApiController do
  @moduledoc """
  An endpoint for the bots to update data
  """

  use FrontendWeb, :controller

  def show(conn, %{"id" => id}) do
    conn
    |> render("show.json", result: Graph.Repo.get!(id))
  end

  def search(conn, %{"query" => query}) do
    conn
    |> render("results.json", result: Meilisearch.Search.search("items", query))
  end

  def query(conn, %{"field" => field, "value" => value}) do
    statement = [
      "{uid_get(func: eq(#{field}, #{value})) { uid }}"
    ]

    Dlex.query(Graph.Repo, statement)
    |> case do
      {:ok, %{"uid_get" => values}} ->
        conn
        |> render(
          "query.json",
          %{
            values: Enum.map(values, fn x -> Map.get(x, "uid") end)
          }
        )

      _ ->
        conn
        |> render("query.json", %{})
    end
  end

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
