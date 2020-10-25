defmodule FrontendWeb.BrowseLive.Schema do
  use FrontendWeb, :live_component

  def update(assigns, socket) do
    schema =
      assigns
      |> Map.get(:type)
      |> Map.get(:model)
      |> schema()
      |> IO.inspect()

    {:ok, assign(socket, type: assigns.type, schema: schema, current_user: assigns.current_user)}
  end

  defp schema(module) do
    module.__schema__(:field_config)
    |> Enum.sort_by(& &1.sorted)
    |> Enum.map(fn item ->
      item
      |> Map.put(:db_name, module.__schema__(:field, item.name))
      |> Map.put(:type, map_field(item.name, module))
      |> Map.put(:models, module.__schema__(:models, item.name))
    end)
  end

  defp map_field(name, module) do
    {_, type} = module.__schema__(:field, module.__schema__(:field, name))

    type
  end

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

  def into_url(_predicate, nil), do: nil

  def into_url(predicate, value) do
    predicate
    |> Map.get("config", %{})
    |> Map.get(:url, ":value:")
    |> String.replace(":value:", value |> to_string(), global: true)
  end

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
