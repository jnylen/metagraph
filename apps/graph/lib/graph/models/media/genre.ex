defmodule Graph.Media.Genre do
  use Graph.Schema

  schema "media_genre" do
    field(:label, :auto, lang: true, depends_on: Graph.Core.Common)
    field(:description, :auto, lang: true, depends_on: Graph.Core.Common)

    relation(:media, :reverse, model: Graph.Core.Media, name: :genre)
  end

  schema_config do
    node_config(:label, "Media Genre")
    # node_config(:icon, "fas fa-photo-video")
    node_config(:hidden, false)

    field_config(:label, sorted: 1, template: "special/lang_string")

    field_config(:description,
      sorted: 2,
      template: "special/lang_text"
    )

    field_config(:media, sorted: 3)
  end

  def changeset(genre, params \\ %{}) do
    genre
    |> cast(params, [])
    |> cast_embed(:label)
    |> cast_embed(:description)
  end
end
