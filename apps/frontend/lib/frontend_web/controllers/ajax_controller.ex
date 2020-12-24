defmodule FrontendWeb.AjaxController do
  @moduledoc """
  Allows AJAX API Calls to fetch and return data
  """

  use FrontendWeb, :controller

  alias FrontendWeb.GraphHelper

  @doc """
  Find relations based on query
  """
  def relations(conn, %{"type" => type, "q" => query} = params) do
    language = Map.get(params, "lang", "en-US")

    regex = query |> String.downcase() |> String.trim()

    by_label = """
    query by_label($label: string, $type: string, $language: string) {
      by_label(func: match(common.label@#{language}, $label, 8)) @filter(type($type)) {
        uid
        dgraph.type
        label : common.label@#{language}
      }
    }
    """

    {:ok, %{"by_label" => results}} =
      Dlex.query(Graph.Repo, by_label, %{
        "$label" => regex,
        "$type" => String.downcase(type)
      })
      |> IO.inspect()

    render(conn, "relations.json", results: results)
  end

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

  def save(conn, %{"modal" => params}) do
    GraphHelper.get_module(Map.get(params, "type")).changeset(
      struct(GraphHelper.get_module(Map.get(params, "type"))),
      params |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end) |> IO.inspect()
    )
    |> IO.inspect()

    # |> Editor.create(conn.assigns.current_user)
    # |> case do
    #   {:ok, item} ->
    #     IO.inspect(item)
    #     render(conn, "save.json", response: {:ok, item})

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     IO.inspect(changeset)
    #     render(conn, "save.json", response: {:error, changeset})
    # end
  end
end
