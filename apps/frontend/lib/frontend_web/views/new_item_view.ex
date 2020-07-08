defmodule FrontendWeb.NewItemView do
  @moduledoc false

  import FrontendWeb.ItemHelpers

  import FrontendWeb.ChangeHelpers
  #import Phoenix.HTML.SimplifiedHelpers.TimeAgoInWords

  # import Phoenix.HTML.SimplifiedHelpers.NumberWithDelimiter

  use FrontendWeb, :view

  def link_to_remove_association() do

  end

  def render_association() do

  end

  def link_to_add_association(label, view_module \\ nil, view_template \\ nil, opts \\ []) do
    data = [
      association: Keyword.get(opts, :association),
      associations: Keyword.get(opts, :associations),
      association_insertion_template: Phoenix.View.render_to_string(view_module, view_template, opts),
      association_insertion_node: Keyword.get(opts, :insertion_node),
      association_insertion_method: "append"
    ]


     link(label, to: "#", class: "add_fields", data: data)
  end

  def textarea_no_name(form, field, opts \\ []) do
    opts =
      opts
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))

    #{value, opts} = Keyword.pop(opts, :value, input_value(form, field))
    content_tag(:textarea, ["\n", html_escape("")], opts)
  end

  def select_no_name(form, field, options, opts \\ []) when is_atom(field) or is_binary(field) do
    #{selected, opts} = selected(form, field, opts)
    options_html = options_for_select(options, nil)

    {options_html, opts} =
      case Keyword.pop(opts, :prompt) do
        {nil, opts} -> {options_html, opts}
        {prompt, opts} -> {[content_tag(:option, prompt, value: "") | options_html], opts}
      end

    opts =
      opts
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))

    content_tag(:select, options_html, opts)
  end

  def text_input_no_name(form, field, opts \\ []) do
    generic_input_no_name(:text, form, field, opts)
  end

  defp maybe_html_escape(nil), do: nil
  defp maybe_html_escape(value), do: html_escape(value)

  defp generic_input_no_name(type, form, field, opts)
       when is_list(opts) and (is_atom(field) or is_binary(field)) do
    opts =
      opts
      |> Keyword.put_new(:type, type)
      |> Keyword.put_new(:id, input_id(form, field))
      |> Keyword.put_new(:name, input_name(form, field))
      #|> Keyword.put_new(:value, input_value(form, field))
      #|> Keyword.update!(:value, &maybe_html_escape/1)

    tag(:input, opts)
  end

  def active_link?(link, active_link) do
    default_classes = "px-4 py-2 mr-3"

    if link != active_link do
      default_classes
    else
      "#{default_classes} rounded-lg bg-brand-activemenubg text-brand-activemenutext"
    end
  end

  def count_keys(item) do
    Map.from_struct(item)
    |> Enum.into([])
    |> Enum.reject(fn {_key, value} -> empty_value?(value) end)
    |> Enum.count()
  end

  def count_facts(item) do
    {_, amount} =
      Map.from_struct(item)
      |> Enum.into([])
      |> Enum.reject(fn {_key, value} -> empty_value?(value) end)
      |> Enum.map_reduce(0, fn {_key, value}, acc ->
        {value, acc + value_amount(value)}
      end)

    amount
  end

  defp empty_value?([]), do: true
  defp empty_value?(nil), do: true
  defp empty_value?(""), do: true
  defp empty_value?(_), do: false

  defp value_amount(list) when is_list(list), do: Enum.count(list)
  defp value_amount(_), do: 1

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
