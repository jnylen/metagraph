defmodule FrontendWeb.AjaxController do
  @moduledoc """
  Allows AJAX API Calls to fetch and return data
  """

  use FrontendWeb, :controller

  @doc """
  Find edges depending on a type or multiple types
  """
  def find_edges(conn, %{"edges" => _, "query" => nil} = _params),
    do: render(conn, "find_edges.json", result: [])

  def find_edges(conn, %{"edges" => _, "query" => ""} = _params),
    do: render(conn, "find_edges.json", result: [])

  def find_edges(conn, %{"edges" => edges, "query" => query} = _params) do
    edge_types = edges |> Enum.join(", ")

    {:ok, %{"query" => result}} =
      """
      {
        query(func: type(#{edge_types})) @filter(regexp(common.label@en-US, /.*#{query}.*/i)) {
          uid
          common.label@en-US
          dgraph.type
        }
      }
      """
      |> IO.inspect()
      |> Graph.Repo.all()
      |> IO.inspect()

    render(conn, "find_edges.json", result: result)
  end

  def find_edges(conn, _params),
    do: render(conn, "find_edges.json", result: [])

  @doc """
  Save a change of an edge to the item
  """
  def save(conn, %{"uid" => uid, "predicate" => predicate, "value" => value}) do
    response =
      Frontend.Editor.update(
        uid,
        %{
          (predicate |> String.to_existing_atom()) => value
        },
        conn.assigns.current_user
      )

    render(conn, "save.json", response: response)
  end
end
