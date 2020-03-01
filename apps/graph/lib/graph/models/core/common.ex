defmodule Graph.Core.Common do
  use Graph.Schema

  shared "common" do
    field(:label, :string, lang: true, index: ["trigram"], template: "special/lang_string")

    field(:description, :string,
      lang: true,
      template: "special/lang_text"
    )

    field(:website, :string, template: "_string")
  end

  schema_config do
    node_config(:hidden, true)
  end
end
