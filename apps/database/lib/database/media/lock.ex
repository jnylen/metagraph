defmodule Database.Media.Lock do
  @moduledoc """
  A Lock of a item
  """
  use Database.Schema

  schema "locks" do
    field(:subject, :string)
    field(:predicate, :string)

    timestamps()
  end

  def changeset(channel, params \\ %{}) do
    channel
    |> cast(params, [
      :subject,
      :predicate
    ])
    |> validate_required([:subject, :predicate])

    # |> validate_document_types
  end
end
