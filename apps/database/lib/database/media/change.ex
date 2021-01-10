require Protocol
Protocol.derive(Jason.Encoder, Auditor.Change)
Protocol.derive(Jason.Encoder, Dlex.Lang)

defmodule Database.Media.Change do
  @moduledoc """
  A Change for an item
  """
  use Database.Schema

  schema "changes" do
    field(:action, :string)
    field(:subject, :string)
    field(:original, :map)
    field(:changes, {:array, :map})

    belongs_to(:user, Database.Account, foreign_key: :actor)

    timestamps()
  end

  def changeset(edit, params \\ %{}) do
    edit
    |> cast(params, [:action, :subject, :original, :changes])
    |> validate_required([:action, :subject])
    |> put_assoc(:user, params.actor)
  end

  def insert(
        %Auditor.Entry{action: action, actor: actor, subject: subject, changes: changes} = _entry
      ) do
    changes =
      changes
      |> Enum.filter(fn item ->
        Enum.member?([:ins, :diff, :del], item.action)
      end)

    Que.add(
      Worker.Editor.Auditor,
      %{action: action, actor: actor.id, subject: subject, changes: changes}
    )
  end

  def update_meili({:ok, %{uid: uid}}), do: update_meili(uid)
  def update_meili(%{uid: uid}), do: update_meili(uid)

  def update_meili(uid) do
    statement = [
      "{ query(func: uid(",
      uid,
      ")) { uid type : dgraph.type label : common.label@* description : common.description@* } }"
    ]

    with {:ok, %{"query" => nodes}} <- Dlex.query(Graph.Repo, statement) do
      Meilisearch.Document.add_or_replace("items", nodes)
    end
  end
end
