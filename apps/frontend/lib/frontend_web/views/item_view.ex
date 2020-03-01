defmodule FrontendWeb.ItemView do
  @moduledoc false

  import FrontendWeb.ItemHelpers
  import FrontendWeb.ChangeHelpers
  import Phoenix.HTML.SimplifiedHelpers.TimeAgoInWords
  import Phoenix.HTML.SimplifiedHelpers.NumberWithDelimiter

  use FrontendWeb, :view

  def render_item_template(predicate, item, type \\ "type", folder)

  def render_item_template(predicate, item, "type", folder) do
    cond do
      predicate["config"][:template] ->
        render_existing(
          FrontendWeb.ItemView,
          "#{folder}/type/#{predicate["config"][:template]}.html",
          predicate: predicate,
          item: item
        )

      predicate["type"] ->
        render_existing(FrontendWeb.ItemView, "#{folder}/type/_#{predicate["type"]}.html",
          predicate: predicate,
          item: item
        )

      true ->
        render_existing(FrontendWeb.ItemView, "#{folder}/type/_default.html",
          predicate: predicate,
          item: item
        )
    end
  end

  def render_item_template(predicate, item, "domain", folder) do
    IO.inspect(predicate)

    cond do
      predicate["config"][:template] ->
        render_existing(
          FrontendWeb.ItemView,
          "#{folder}/domain/#{predicate["config"][:template]}.html",
          predicate: predicate,
          item: item
        )

      predicate["type"] ->
        render_existing(FrontendWeb.ItemView, "#{folder}/domain/_#{predicate["type"]}.html",
          predicate: predicate,
          item: item
        )

      true ->
        render_existing(FrontendWeb.ItemView, "#{folder}/domain/_default.html",
          predicate: predicate,
          item: item
        )
    end
  end

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

  def lang_input(form, field) do
    values = Phoenix.HTML.Form.input_value(form, field) || [""]
    id = Phoenix.HTML.Form.input_id(form, field)

    content_tag :ol,
      id: container_id(id),
      class: "input_container pt-4 flex flex-col text-indigo-900",
      data: [index: Enum.count(values)] do
      values
      |> Enum.map(fn %{language: index, value: value} ->
        form_elements(form, field, value, index)
      end)
    end
  end

  defp form_elements(form, field, value, index) do
    type = type(form, field)
    id = Phoenix.HTML.Form.input_id(form, field)
    new_id = id <> "_#{index}"

    input_opts = [
      name: new_field_name(form, field, index) <> "[value]",
      value: value,
      rows: 6,
      id: new_id,
      class:
        "bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-indigo-700 w-full"
    ]

    content_tag :li, class: "flex w-full #{lang_pos(type)} mb-2" do
      [
        apply(Phoenix.HTML.Form, :hidden_input, [
          form,
          field,
          [
            name: new_field_name(form, field, index) <> "[language]",
            value: index
          ]
        ]),
        content_tag :div, class: "leading-snug font-medium w-1/3" do
          Graph.Struct.Language.find(:code, index).name
        end,
        content_tag :div, class: "pl-8 flex-1" do
          apply(Phoenix.HTML.Form, type, [form, field, input_opts])
        end
      ]
    end
  end

  defp container_id(id), do: id <> "_container"

  defp new_field_name(form, field, index) do
    Phoenix.HTML.Form.input_name(form, field) <> "[#{index}]"
  end

  defp type(_, :description), do: :textarea
  defp type(form, field), do: Phoenix.HTML.Form.input_type(form, field)

  defp lang_pos(:textarea), do: "items-top"
  defp lang_pos(_), do: "items-center"
end
