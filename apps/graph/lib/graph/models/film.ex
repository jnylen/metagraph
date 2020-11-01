defmodule Graph.Film do
  use Graph.Schema

  schema "film" do
    field(:label, :auto, lang: true, depends_on: Graph.Core.Common)
    field(:description, :auto, lang: true, depends_on: Graph.Core.Common)
    field(:website, :auto, depends_on: Graph.Core.Common)
    field(:budget, :auto, depends_on: Graph.Core.Media)
    field(:revenue, :auto, depends_on: Graph.Core.Media)
    field(:wikidata_id, :auto, depends_on: Graph.Core.Media)
    field(:imdb_id, :auto, depends_on: Graph.Core.Media)
    field(:freebase_id, :auto, depends_on: Graph.Core.Media)
    field(:themoviedb_id, :integer, index: true)
    field(:omdb_id, :integer, index: true)
    field(:elonet_id, :integer, index: true)

    field(:genre, :auto,
      depends_on: Graph.Core.Media,
      models: Graph.Core.Media.__schema__(:models, :genre)
    )

    relation(:performances, :reverse, model: Graph.Mediator.Performance, name: :film)
  end

  schema_config do
    node_config(:label, "Film")
    node_config(:icon, "fas fa-film")
    node_config(:description, "Sequence of images that give the impression of movement")
    node_config(:hidden, false)
    node_config(:allow_image_upload, true)

    field_config(:label, sorted: 1, template: "special/lang_string")
    field_config(:description, sorted: 2, template: "special/lang_text")
    field_config(:website, sorted: 3, template: "_string")

    field_config(:performances,
      sorted: 3,
      label: "Performances",
      tags: ["mediator"],
      mediator: true,
      depends_on: Graph.Mediator.Performance,
      field_name: :film,
      template: "mediator/list"
    )

    field_config(:imdb_id,
      sorted: 4,
      external: true,
      label: "IMDB ID",
      example: "tt7430722",
      url: "https://imdb.com/title/:value:",
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

    field_config(:themoviedb_id,
      sorted: 6,
      external: true,
      label: "TheMovieDB ID",
      example: "11212121",
      url: "https://www.themoviedb.org/film/:value:",
      template: "_url"
    )

    field_config(:omdb_id,
      sorted: 7,
      external: true,
      label: "Open Media Database ID",
      example: "11212121",
      url: "https://www.omdb.org/movie/:value:",
      template: "_url"
    )

    field_config(:elonet_id,
      sorted: 8,
      external: true,
      label: "Elonet ID",
      example: "11212121",
      url: "https://elonet.finna.fi/Record/kavi.elonet_elokuva_:value:",
      template: "_url"
    )

    field_config(:wikidata_id,
      sorted: 9,
      external: true,
      label: "Freebase ID",
      example: "/m/0dr_4",
      depends_on: Graph.Core.Media,
      url: "https://tools.wmflabs.org/freebase/:value:",
      template: "_url"
    )

    field_config(:budget,
      sorted: 10,
      template: "_currency"
    )

    field_config(:revenue,
      sorted: 11,
      template: "_currency"
    )

    field_config(:genre,
      sorted: 12,
      relations: true,
      label: "Genre",
      template: "relations/simple_many"
    )
  end

  def changeset(film, params \\ %{}) do
    film
    |> cast(params, [
      :website,
      :budget,
      :revenue,
      :wikidata_id,
      :imdb_id,
      :themoviedb_id,
      :freebase_id,
      :omdb_id,
      :elonet_id,
      :genre
    ])
    |> cast_embed(:label, with: &Graph.Struct.Language.changeset/2)
    |> cast_embed(:description, with: &Graph.Struct.Language.changeset/2)
    |> validate_number(:themoviedb_id, greater_than_or_equal_to: 1)
    |> validate_number(:omdb_id, greater_than_or_equal_to: 1)
    |> validate_number(:elonet_id, greater_than_or_equal_to: 1)
    |> validate_number(:budget, greater_than_or_equal_to: 1)
    |> validate_number(:revenue, greater_than_or_equal_to: 1)
    |> validate_format(:website, ~r/^http(s|)\:\/\//)
    |> validate_format(:wikidata_id, ~r/^Q(\d+)$/)
    |> validate_format(:imdb_id, ~r/^tt(\d{7,8})$/)
    |> validate_relation(:genre)
  end
end
