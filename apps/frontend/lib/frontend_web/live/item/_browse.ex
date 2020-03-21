defmodule FrontendWeb.ItemLive.Browse do
  use FrontendWeb, :live_component

  def render(%{template: "menu"} = assigns) do
    FrontendWeb.NewItemView.render("browse/_menu.html", assigns)
  end

  def render(%{menu: "index"} = assigns) do
    {:ok, %{"queries" => items}} =
      assigns
      |> Map.get(:type)
      |> Map.get(:model)
      |> Graph.Repo.paginate(nil)

    assigns =
      assigns
      |> Map.put(
        :items,
        items
      )

    FrontendWeb.NewItemView.render("browse/index.html", assigns)
  end

  def render(%{menu: "index_item"} = assigns) do
    FrontendWeb.NewItemView.render("browse/_item.html", assigns)
  end

  def render(%{menu: "schema"} = assigns) do
    schema =
      assigns
      |> Map.get(:type)
      |> Map.get(:model)
      |> schema()
      |> IO.inspect()

    assigns =
      assigns
      |> Map.put(:schema, schema)

    FrontendWeb.NewItemView.render("browse/schema.html", assigns)
  end

  def render(%{menu: "queries"} = assigns) do
    assigns =
      assigns
      |> Map.put(:items, [])

    FrontendWeb.NewItemView.render("browse/queries.html", assigns)
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
end
