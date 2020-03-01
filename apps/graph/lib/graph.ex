defmodule Graph do
  @moduledoc """
  Handle insertion to Dgraph using Dlex.
  """

  alias Graph.Schema

  @doc """
  Get items for all uids in a list
  """
  def get_all(uids) do
        langs =
      Map.get(Graph.Repo.meta(), :modules, [])
      |> Enum.map(&Dlex.Repo.grab_all_langs/1)
      |> Enum.concat()
      |> Enum.uniq()
      |> Enum.join(" ")
      |> String.trim()

    statement = [
      "{uid_get(func: uid(",
      uids |> Enum.uniq() |> Enum.join(", "),
      ")) {uid dgraph.type #{langs} expand(_all_) { uid dgraph.type #{langs} expand(_all_)}}}"
    ]

    with {:ok, %{"uid_get" => nodes}} <- Graph.Repo.all(statement) do
      nodes
      #|> Enum.reject(&is_nil(&1["dgraph.type"]))
    end
  end

  @doc """
  Insert an item
  """
  def insert(params, current_user)
      when is_map(params) do
    params
    |> Graph.Repo.set()
    |> case do
      {:ok, item} ->
        Auditor.emit(:insert, current_user, item, nil)
        {:ok, item}

      response ->
        response
    end
  end

  def insert(_, _), do: {:error, "not a struct"}

  @doc """
  Update an item
  """
  def update(params, %{uid: uid} = _old_item, current_user)
      when is_binary(uid) and is_map(params) do
    # Validate the params and emit audit
    params
    |> Schema.not_locked?(uid)
    |> case do
      {:ok, item} ->
        item
        |> Graph.Repo.set()

      response ->
        response
    end
    |> case do
      # TODO: Add current user
      {:ok, item} ->
        Auditor.emit(:update, current_user, item, params)
        {:ok, item}

      response ->
        response
    end
  end

  def update(_, _, _), do: {:error, "not a string or/and a struct"}
end
