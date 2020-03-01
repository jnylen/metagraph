defmodule FrontendWeb.NewItemView do
  @moduledoc false

  import FrontendWeb.ItemHelpers

  import FrontendWeb.ChangeHelpers
  import Phoenix.HTML.SimplifiedHelpers.TimeAgoInWords

  # import Phoenix.HTML.SimplifiedHelpers.NumberWithDelimiter

  use FrontendWeb, :view

  def into_url(_predicate, nil), do: nil

  def into_url(predicate, value) do
    predicate
    |> Map.get("config", %{})
    |> Map.get(:url, ":value:")
    |> String.replace(":value:", value |> to_string(), global: true)
  end

  def cleanup_map!(map) when is_map(map) do
    map
    |> Map.delete(:form)
    |> Map.delete("config")
  end

  def cleanup_map!(var), do: var

  def parse_type(:reverse_relation, predicate) do
    predicate |> IO.inspect()

    {
      "Reverse Relation",
      [Map.get(predicate, :depends_on)]
      |> into_urls()
    }
  end

  def parse_type(:lang, _predicate) do
    {
      "String (@lang)",
      []
    }
  end

  def parse_type(:relations, predicate) do
    {
      "Has many",
      predicate.models
      |> into_urls()
    }
  end

  def parse_type(:relation, predicate) do
    {
      "Has one",
      predicate.models
      |> into_urls()
    }
  end

  def parse_type(type, _predicate), do: {type |> to_string |> String.capitalize(), []}

  defp into_urls(models) do
    models
    |> Enum.map(fn model ->
      unless is_nil(model) do
        Phoenix.HTML.Link.link(model.schema_label,
          to: "/browse/#{model.__schema__(:source)}/schema",
          class: "text-indigo-600 hover:text-indigo-700 underline"
        )
      end
    end)
  end
end
