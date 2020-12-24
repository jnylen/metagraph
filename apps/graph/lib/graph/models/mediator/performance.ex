defmodule Graph.Mediator.Performance do
  use Graph.Schema

  schema "performance" do
    relation(:film, :one, models: [Graph.Film], reverse: true)
    relation(:person, :one, models: [Graph.Person], reverse: true)
    # relation(:version, :one, models: [Graph.Version], reverse: true)
    # relation(:tv_episode, :one, models: [Graph.Tv.Episode], reverse: true)
    # relation(:spoken_language, :one, models: [Graph.Language])
    # relation(:roles, :many, models: [Graph.Character])
    # field(:note, :string, lang: true, index: ["trigram"])
  end

  schema_config do
    node_config(:label, "Performance")
    node_config(:type, "mediator")
    node_config(:description, "A person that is performing in a media item.")
    node_config(:hidden, true)

    # node_config(:allow_image_upload, true)

    field_config(:film,
      relations: true,
      sorted: 1,
      depends_on: Graph.Film,
      template: "relations/simple_one"
    )

    field_config(:person,
      relations: true,
      sorted: 2,
      depends_on: Graph.Person,
      template: "relations/simple_one"
    )

    field_config(:note, sorted: 3, template: "special/lang_string")
  end

  def changeset(performance, params \\ %{}) do
    performance
    |> cast(params, [:film, :person])
    |> validate_relation(:film)
    |> validate_relation(:person)

    # |> cast_embed(:label, with: &Graph.Struct.Language.changeset/2)
    # |> cast_embed(:description, with: &Graph.Struct.Language.changeset/2)
  end
end
