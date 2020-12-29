defmodule Graph.Mediator.Crew do
  use Graph.Schema

  @job_choices [
    [
      key: "Director",
      value: "director"
    ],
    [
      key: "Writer",
      value: "writer"
    ],
    [
      key: "Producer",
      value: "producer"
    ],
    [
      key: "Executive Producer",
      value: "executive_producer"
    ]
  ]

  schema "crew" do
    relation(:film, :one, models: [Graph.Film], reverse: true)
    relation(:person, :one, models: [Graph.Person], reverse: true)
    # relation(:version, :one, models: [Graph.Version], reverse: true)
    # relation(:tv_episode, :one, models: [Graph.Tv.Episode], reverse: true)
    field(:job, :string, index: ["trigram"])
    # field(:note, :string, lang: true, index: ["trigram"])
  end

  schema_config do
    node_config(:label, "Crew")
    node_config(:type, "mediator")
    node_config(:description, "A person that is a crew in a media item (for example director).")
    node_config(:hidden, true)

    # node_config(:allow_image_upload, true)

    field_config(:job,
      sorted: 1,
      label: "Job",
      template: "_select_one",
      choices: @job_choices
    )

    field_config(:film,
      relations: true,
      sorted: 2,
      label: "Film",
      depends_on: Graph.Film,
      template: "relations/simple_one"
    )

    field_config(:person,
      relations: true,
      sorted: 3,
      label: "Person",
      depends_on: Graph.Person,
      template: "relations/simple_one"
    )

    # field_config(:note, sorted: 3, template: "special/lang_string")
  end

  def changeset(performance, params \\ %{}) do
    performance
    |> cast(params, [:job])
    |> fill_relation(params, :film)
    |> fill_relation(params, :person)
    |> validate_relation(:film)
    |> validate_relation(:person)
    |> validate_inclusion(:job, @job_choices |> Enum.map(fn job -> Keyword.get(job, :value) end))
    |> validate_required(:job)
    |> validate_required_list(:person)

    # |> cast_embed(:label, with: &Graph.Struct.Language.changeset/2)
    # |> cast_embed(:description, with: &Graph.Struct.Language.changeset/2)
  end
end
