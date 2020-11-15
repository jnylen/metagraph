defmodule Graph.Core.Media do
  use Graph.Schema

  shared "media" do
    field(:budget, :integer)
    field(:revenue, :integer)
    field(:adult, :boolean)
    field(:wikidata_id, :string, index: ["term"])
    field(:imdb_id, :string, index: ["term"])
    field(:freebase_id, :string, index: ["term"])

    relation(:genre, :many, models: [Graph.Media.Genre], reverse: true)
  end

  schema_config do
    node_config(:hidden, true)

    field_config(:wikidata_id,
      url: "https://wikidata.org/wiki/:value:",
      label: "Wikidata ID",
      example: "Q121212",
      template: "_url"
    )

    field_config(:freebase_id,
      url: "https://tools.wmflabs.org/freebase/:value:",
      label: "Freebase ID",
      example: "/m/0dr_4",
      template: "_url"
    )
  end
end
