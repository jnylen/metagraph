defmodule Editor do
  @moduledoc """
  Documentation for `Editor`.
  """

  alias Editor.Schema

  @doc """
  Create an item with the specific values
  """
  def create(changeset, actor),
    do:
      changeset
      |> AuditorDlex.insert(actor)
      |> IO.inspect()

  @doc """
  Update an item with values
  """
  def update(changeset, actor),
    do:
      changeset
      |> Schema.check(:update, actor)

  def delete(uid, actor) do
  end

  def lock(uid, "*", actor) do
  end

  def lock(uid, predicate, actor) do
  end
end
