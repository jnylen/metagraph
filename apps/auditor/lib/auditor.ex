require Protocol
Protocol.derive(Jason.Encoder, Dlex.Lang, except: [:uid])

defmodule Auditor do
  @moduledoc """
  Documentation for Auditor.
  """

  @doc """
  Emit a edit
  """
  def emit(action, actor, item, changes) do
    :telemetry.execute([:dgraph, :item, action], actor, %{item: item, changes: changes})
  end

  @doc """
  Log an insertion of an item
  """
  def log(:delete, actor, %{uid: uid} = item, _) do
    %Database.Media.Change{}
    |> Database.Media.Change.changeset(%{
      action: "delete",
      actor: actor,
      subject: uid,
      changes: nil,
      original: item
    })
    |> Database.Repo.insert()
  end

  @doc """
  Log an insertion of an item
  """
  def log(:insert, actor, %{uid: uid} = item, _) do
    %Database.Media.Change{}
    |> Database.Media.Change.changeset(%{
      action: "insert",
      actor: actor,
      subject: uid,
      changes: diff_map(%{}, item),
      original: nil
    })
    |> IO.inspect()
    |> Database.Repo.insert()
    |> IO.inspect()
  end

  @doc """
  Log an update of an item
  """
  def log(:update, actor, item, %{changes: changes}), do: log(:update, actor, item, changes)

  def log(:update, actor, %{uid: uid} = item, new_data) do
    %Database.Media.Change{}
    |> Database.Media.Change.changeset(%{
      action: "update",
      actor: actor,
      subject: uid,
      changes: diff_map(item, new_data),
      original: nil
    })
    |> Database.Repo.insert()

    # If no user data get current_user
    # Compare old and new values to find what is changed
    # Build logger obj
    # Create
  end

  @doc """
  List all edits for an item
  """
  def list_edits(%{"uid" => uid}) do
    import Ecto.Query, only: [from: 2]

    from(e in Database.Media.Change,
      where:
        e.subject ==
          ^uid
    )
    |> Database.Repo.all()
  end

  # Diff two maps
  def diff_map(original, changes) do
    MapDiff.diff(clean_item(original), clean_item(changes))
    |> IO.inspect()
    |> Map.get(:value)
  end

  # Remove uid etc from an item
  defp clean_item(map) when is_map(map) do
    map
    |> Map.delete(:__struct__)
    |> Map.delete(:uid)
  end
end
