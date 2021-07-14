defmodule FrontendWeb.ItemHelpers do
  def get_predicate_types(struct, %{"types" => [%{"fields" => fields}]}, field_config),
    do: get_predicate_types(struct, fields, field_config)

  def get_predicate_types(struct, list, field_config) when is_list(list) do
    list
    |> Enum.map(fn item ->
      {field_name, type} = struct.__schema__(:field, item["name"])

      %{
        "real_name" => item["name"],
        "name" => field_name,
        "type" => type,
        "models" =>
          struct.__schema__(:models, field_name)
          |> Enum.map(fn model ->
            model.__schema__(:source)
          end),
        "section" =>
          item["name"]
          |> String.split(".")
          |> List.first(),
        "config" =>
          field_config
          |> Enum.find(fn field ->
            field.name == field_name
          end)
      }
    end)
  end

  def get_sections(types) do
    types
    |> Enum.map(fn i ->
      name =
        i["real_name"]
        |> String.split(".")
        |> List.first()

      map = %{
        "id" => name,
        "name" =>
          name
          |> prettify_predicate()
      }

      config = Map.get(i, "config", %{}) || %{}

      cond do
        config |> Map.get(:mediator, false) ->
          map
          |> Map.put("config", Map.get(i, "config", %{}))

        config |> Map.get(:sorted, 999) ->
          map
          |> Map.put(
            "config",
            %{
              sorted: Map.get(config, :sorted, 999)
            }
          )

        true ->
          map
      end
    end)
    |> Enum.uniq_by(& &1["id"])
    |> Enum.sort_by(&(&1["config"].sorted || &1["id"]))
  end

  def prettify_predicate(%{"config" => %{label: label}}) when not is_nil(label), do: label
  def prettify_predicate(%{"name" => name}) when not is_nil(name), do: prettify_predicate(name)

  def prettify_predicate(name) do
    name
    |> to_string()
    |> String.replace("~", "")
    |> String.split("_")
    |> Enum.join(" ")
    |> String.capitalize()
  end

  @doc """
  Get a type from struct
  """
  def get_type(%{__struct__: struct}) do
    struct.schema_label
    |> Phoenix.HTML.Link.link(
      to: "/browse/#{struct.__schema__(:source)}",
      class: "hover:underline"
    )
  end

  def get_type(%{"type" => type}) when is_list(type) do
    type
    |> List.first()
    |> prettify_predicate()
  end

  def get_type(_), do: "Unknown"

  @doc """
  Get a translation by lang
  """
  def get_lang(list, lang) when is_list(list) do
    list
    |> Enum.filter(fn item ->
      (Map.get(item, :language) || Map.get(item, "language")) == lang
    end)
    |> case do
      [item] -> item
      _ -> get_one(list)
    end
  end

  def get_lang(map, _) when is_map(map), do: map

  def get_lang(_, _), do: %{}

  def get_one([item | _]), do: item

  def get_one([]), do: %{}

  def rels_into_ajax([]), do: []
  def rels_into_ajax(nil), do: []

  def rels_into_ajax([item | list]) do
    [rels_into_ajax(item) | rels_into_ajax(list)]
  end

  def rels_into_ajax(%{} = map) do
    %{
      type: [map.__struct__.__schema__(:source)],
      label: Map.get(get_lang(Map.get(map, :label, []), "sv-SE"), :value, "Unknown"),
      uid: map.uid
    }
  end
end
