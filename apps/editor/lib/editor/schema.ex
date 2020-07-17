defmodule Editor.Schema do
  def check(actual_item, changeset, :update, actor) do
    changeset
    |> not_locked?()
    |> case do
      {:ok, item} ->
        actual_item
        |> AuditorDlex.update(changeset, actor)

      response ->
        response
    end
  end

  def check(actual_item, changeset, :delete, actor) do
    :not_implemented
  end

  @doc """
  Check so item and each predicate isn't locked.
  """
  defp not_locked?(changes) do
    locks =
      Database.get_locks_for_item(Ecto.Changeset.get_field(changes, :uid))
      |> Enum.map(& &1.predicate)

    # If it has * then the whole item is locked.
    if Enum.member?(locks, "*") do
      {:error, "item is locked"}
    else
      predicates =
        changes
        |> Map.keys()
        |> Enum.map(&to_string(&1))

      # Check if the predicates is in locks.
      Enum.any?(predicates, fn pred ->
        Enum.member?(locks, pred)
      end)
      |> case do
        true -> {:error, "a predicate is locked"}
        false -> {:ok, changes}
      end
    end
  end
end
