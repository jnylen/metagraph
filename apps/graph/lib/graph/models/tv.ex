defmodule Graph.Tv do
  use Graph.Schema

  schema "tv" do
    field(:label, :auto, lang: true, depends_on: Graph.Core.Common)
    field(:description, :auto, lang: true, depends_on: Graph.Core.Common)
    field(:website, :auto, depends_on: Graph.Core.Common)
    field(:wikidata_id, :auto, depends_on: Graph.Core.Media)
    field(:imdb_id, :auto, depends_on: Graph.Core.Media)
    field(:freebase_id, :auto, depends_on: Graph.Core.Media)
    field(:themoviedb_id, :integer, index: true)
    field(:thetvdb_id, :integer, index: true)

    field(:genre, :auto,
      depends_on: Graph.Core.Media,
      models: Graph.Core.Media.__schema__(:models, :genre)
    )
  end

  schema_config do
    node_config(:label, "TV")
    node_config(:icon, "fas fa-tv")
    node_config(:description, "Sequence of images that give the impression of movement")
    node_config(:hidden, false)
    node_config(:allow_image_upload, true)

    field_config(:label, sorted: 1, template: "special/lang_string")
    field_config(:description, sorted: 2, template: "special/lang_text")
    field_config(:website, sorted: 3, template: "_string")

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
      depends_on: Graph.Core.Media,
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

    field_config(:thetvdb_id,
      sorted: 7,
      external: true,
      label: "TheTVDB ID",
      example: "121212121",
      url: "https://www.thetvdb.com/dereferrer/series/:value:",
      template: "_url"
    )

    field_config(:genre,
      sorted: 10,
      relations: true,
      label: "Genre",
      template: "relations/simple_many"
    )
  end

  def changeset(tv, params \\ %{}) do
    tv
    |> cast(params, [
      :website,
      :wikidata_id,
      :imdb_id,
      :themoviedb_id,
      :thetvdb_id,
      :genre
    ])
    |> cast_embed(:label, with: &Graph.Struct.Language.changeset/2)
    |> cast_embed(:description, with: &Graph.Struct.Language.changeset/2)
    |> validate_number(:themoviedb_id, greater_than_or_equal_to: 1)
    |> validate_format(:website, ~r/^http(s|)\:\/\//)
    |> validate_format(:wikidata_id, ~r/^Q(\d+)$/)
    |> validate_format(:imdb_id, ~r/^tt(\d{7,8})$/)
    |> validate_relation(:genre)
  end
end
