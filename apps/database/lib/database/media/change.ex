defmodule Database.Media.Change do
  @moduledoc """
  A Change for an item
  """
  use Database.Schema

  schema "changes" do
    field(:action, :string)
    field(:subject, :string)
    field(:original, :map)
    field(:changes, :map)

    belongs_to(:user, Database.Account, foreign_key: :actor)

    timestamps()
  end

  def changeset(edit, params \\ %{}) do
    edit
    |> cast(params, [:action, :subject, :original, :changes])
    |> validate_required([:action, :subject])
    |> put_assoc(:user, params.actor)
  end
end
