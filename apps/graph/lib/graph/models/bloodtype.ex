defmodule Graph.Bloodtype do
  use Graph.Schema

  schema "bloodtype" do
    field(:label, :auto, lang: true, depends_on: Graph.Core.Common)
    field(:description, :auto, lang: true, depends_on: Graph.Core.Common)

    relation(:people, :reverse, model: Graph.Person, name: :bloodtype)
  end

  schema_config do
    node_config(:label, "Bloodtype")
    node_config(:icon, "fas fa-tint")
    # node_config(:description, "Sequence of images that give the impression of movement")
    node_config(:hidden, false)

    # node_config(:allow_image_upload, true)

    field_config(:label, sorted: 1)
    field_config(:description, sorted: 2)
  end

  def changeset(genre, params \\ %{}) do
    genre
    |> cast(params, [
      :label,
      :description
    ])
  end
end
