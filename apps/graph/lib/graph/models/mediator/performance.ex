defmodule Graph.Mediator.Performance do
  use Graph.Schema

  schema "performance" do
    relation(:film, :one, models: [Graph.Film], reverse: true)
    relation(:person, :one, models: [Graph.Person], reverse: true)
    # relation(:version, :one, models: [Graph.Version], reverse: true)
    # relation(:tv_episode, :one, models: [Graph.Tv.Episode], reverse: true)
    # relation(:spoken_language, :one, models: [Graph.Language])
    # relation(:roles, :many, models: [Graph.Character])
    field(:note, :string, lang: true, index: ["trigram"])
  end

  schema_config do
    node_config(:label, "Performance")
    node_config(:type, "mediator")
    node_config(:description, "A person that is performing in a media item.")
    node_config(:hidden, true)

    # node_config(:allow_image_upload, true)

    field_config(:film, sorted: 1, template: "relations/simple_one")
    field_config(:person, sorted: 2, template: "relations/simple_one")
    field_config(:note, sorted: 3, template: "special/lang_string")
  end

  def changeset(performance, params \\ %{}) do
    performance
    |> cast(params, [])
    |> cast_embed(:label)
    |> cast_embed(:description)
  end
end
