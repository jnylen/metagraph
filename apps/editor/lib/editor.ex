defmodule Editor do
  @moduledoc """
  Documentation for `Editor`.
  """

  alias Editor.Schema

  @doc """
  Create an item with the specific values
  """
  def create(_, nil), do: {:error, "actor is blank"}
  def create(%Ecto.Changeset{valid?: false} = changeset, _actor), do: {:error, changeset}

  def create(changeset, actor) do
    result =
      changeset
      |> AuditorDlex.insert(actor)

    Database.Media.Change.update_meili(result)

    result
  end

  @doc """
  Update an item with values
  """
  def update(_, _, nil), do: {:error, "actor is blank"}
  def update(_, %Ecto.Changeset{valid?: false} = changeset, _actor), do: {:error, changeset}

  def update(actual_item, changeset, actor) do
    result =
      actual_item
      |> Schema.check(changeset, :update, actor)

    Database.Media.Change.update_meili(result)

    result
  end

  def delete(uid, actor) do
  end

  def lock(uid, "*", actor) do
  end

  def lock(uid, predicate, actor) do
  end
end
