defmodule Graph.Person do
  use Graph.Schema

  schema "person" do
    field(:label, :auto, lang: true, depends_on: Graph.Core.Common)
    field(:description, :auto, lang: true, depends_on: Graph.Core.Common)
    field(:website, :auto, depends_on: Graph.Core.Common)
    field(:birth_day, :datetime)
    # country
    field(:death_day, :datetime)
    # country
    # gender
    relation(:bloodtype, :one, models: [Graph.Bloodtype], reverse: true)
    # celeb agency
    field(:weight, :integer)
    field(:height, :integer)
    # husband
    # wife
    # father
    # mother
    # girlfriend
    field(:themoviedb_id, :integer, index: true)
    field(:imdb_id, :string, index: ["term"])
    field(:freebase_id, :auto, depends_on: Graph.Core.Media)
    field(:wikidata_id, :auto, depends_on: Graph.Core.Media)

    relation(:performances, :reverse, model: Graph.Mediator.Performance, name: :person)
    relation(:crew, :reverse, model: Graph.Mediator.Crew, name: :person)
  end

  schema_config do
    node_config(:label, "Person")
    node_config(:icon, "fas fa-user-alt")
    node_config(:description, "Sequence of images that give the impression of movement")
    node_config(:hidden, false)
    node_config(:allow_image_upload, true)

    field_config(:label, sorted: 1, template: "special/lang_string")
    field_config(:description, sorted: 2, template: "special/lang_text")
    field_config(:website, sorted: 3, template: "_string")
    field_config(:birth_day, sorted: 4, template: "_date")
    field_config(:death_day, sorted: 6, template: "_date")
    field_config(:weight, sorted: 11, template: "_integer")
    field_config(:height, sorted: 12, template: "_integer")

    field_config(:crew,
      sorted: 2,
      label: "Crew",
      tags: ["mediator"],
      mediator: true,
      depends_on: Graph.Mediator.Crew,
      field_name: :person,
      template: "mediator/list",
      component: FrontendWeb.ItemLive.MediatorItem,
      component_view: "special/crew_person"
    )

    field_config(:performances,
      sorted: 3,
      label: "Performances",
      tags: ["mediator"],
      mediator: true,
      depends_on: Graph.Mediator.Performance,
      field_name: :person,
      template: "mediator/list",
      component: FrontendWeb.ItemLive.MediatorItem,
      component_view: "special/performance_person"
    )

    field_config(:themoviedb_id,
      sorted: 18,
      external: true,
      label: "TheMovieDB ID",
      example: "11212121",
      url: "https://www.themoviedb.org/person/:value:",
      template: "_url"
    )

    field_config(:imdb_id,
      sorted: 19,
      external: true,
      label: "IMDB ID",
      example: "nm7430722",
      url: "https://imdb.com/name/:value:",
      template: "_url"
    )

    field_config(:bloodtype,
      sorted: 15,
      relations: true,
      label: "Bloodtype",
      depends_on: Graph.Bloodtype,
      template: "relations/simple_one"
    )

    field_config(:freebase_id,
      sorted: 9,
      external: true,
      label: "Freebase ID",
      example: "/m/0dr_4",
      depends_on: Graph.Core.Media,
      url: "https://tools.wmflabs.org/freebase/:value:",
      template: "_url"
    )

    field_config(:wikidata_id,
      sorted: 5,
      external: true,
      label: "Wikidata ID",
      example: "Q121212",
      depends_on: Graph.Core.Media,
      url: "https://www.wikidata.org/wiki/:value:",
      template: "_url"
    )
  end

  def changeset(person, params \\ %{}) do
    person
    |> cast(params, [
      :website,
      :birth_day,
      :death_day,
      :weight,
      :height,
      :bloodtype,
      :themoviedb_id,
      :imdb_id,
      :freebase_id,
      :wikidata_id
    ])
    |> cast_embed(:label, with: &Graph.Struct.Language.changeset/2)
    |> cast_embed(:description, with: &Graph.Struct.Language.changeset/2)
    |> validate_number(:themoviedb_id, greater_than_or_equal_to: 1)
    |> validate_format(:website, ~r/^http(s|)\:\/\//)
    |> validate_format(:wikidata_id, ~r/^Q(\d+)$/)
    |> validate_format(:imdb_id, ~r/^nm(\d{7,8})$/)
    |> validate_relation(:bloodtype)
  end
end
