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

    %Database.Media.Change{}
    |> Database.Media.Change.changeset(%{
      action: action |> to_string(),
      actor: actor,
      subject: subject.uid,
      changes: changes |> Enum.filter(fn item ->
        Enum.member?([:ins, :diff, :del], item.action)
      end)
    })
    |> Database.Repo.insert()
  end
end
