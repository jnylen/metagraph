defmodule Frontend.Editor do
  @moduledoc """
  Handles incoming item actions
  """

  @doc """
  Create an item with the specific values
  """
  def create(changeset, current_user) do
    changeset
    |> Graph.insert(current_user)
  end

  @doc """
  Update an item with values
  """
  # TODO: Make it use incoming changeset instead
  def update(uid, values, current_user) do
    # Get item
    uid
    |> Graph.Repo.get()
    |> case do
      {:ok, nil} ->
        {:error, "not found"}

      {:ok, item} ->
        changes =
          item.__struct__
          |> to_real_map(values)

        # Changeset
        changeset = item.__struct__.changeset(item, changes)

        unless changeset.changes == %{} do
          changeset
          |> Graph.update(item, current_user)
          |> IO.inspect()
        else
          # |> IO.inspect()

          {:ok, item}
        end

      _ ->
        {:error, "not found"}
    end
  end

  def delete(uid, current_user) do
  end

  def lock(uid, "*", current_user) do
  end

  def lock(uid, predicate, current_user) do
  end

  defp to_real_map(struct, map) do
    map
    |> Enum.map(&map_element(struct, &1))
    |> Enum.into(%{})
  end

  defp map_element(struct, {key, val} = e) do
    e |> IO.inspect()

    struct.__schema__(:type, key |> key_to_atom())
    |> IO.inspect()
    |> case do
      :lang ->
        {key_to_atom(key), langs_from_map(val)}

      :relation ->
        {key_to_atom(key), val |> fix_relation()}

      :relations ->
        {key_to_atom(key), val |> fix_relation()}

      :reverse_relation ->
        {key_to_atom(key), val |> fix_relation()}

      _ ->
        {key_to_atom(key), val}
    end
  end

  defp langs_from_map(list) when is_list(list), do: list |> Enum.map(&langs_from_map/1)

  defp langs_from_map(map) do
    map
    |> Enum.map(fn {_, data} -> struct(Dlex.Lang, data |> map_val_to_atom()) end)
  end

  defp map_val_to_atom(data) do
    for {key, val} <- data, into: %{} do
      {key_to_atom(key), val}
    end
  end

  defp key_to_atom(atom) when is_atom(atom), do: atom
  defp key_to_atom(string), do: string |> String.to_existing_atom()

  defp fix_relation(%{"best_label" => _label} = map) do
    Dlex.Repo.decode(map, Graph.Repo.meta().lookup)
    |> case do
      {:ok, map} -> map
      _ -> nil
    end
  end

  defp fix_relation(map), do: map
end
