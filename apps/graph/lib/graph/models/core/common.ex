defmodule Graph.Core.Common do
  use Graph.Schema

  shared "common" do
    field(:label, :string, lang: true, index: ["term", "trigram"])

    field(:description, :string, lang: true)

    field(:website, :string)
  end

  schema_config do
    node_config(:hidden, true)
  end
end
