defmodule Graph.Schema do
  @moduledoc """
  The schema validation library
  """

  defmacro __using__(_) do
    quote do
      @derive Jason.Encoder

      use Dlex.Node
      use Dlex.Changeset

      import Graph.Schema, only: [schema_config: 1, validate_required_list: 2]
    end
  end

  defmacro schema_config(block) do
    prepare = prepare_config(block)
    pp = config_postprocess()

    quote do
      unquote(prepare)
      unquote(pp)
    end
  end

  defp prepare_config(block) do
    quote do
      Module.register_attribute(__MODULE__, :field_config, accumulate: true)
      Module.register_attribute(__MODULE__, :external_fields, accumulate: true)
      Module.register_attribute(__MODULE__, :node_config, accumulate: true)

      import Graph.Schema
      unquote(block)
    end
  end

  defp config_postprocess do
    quote unquote: false do
      # Node configs
      def schema_label, do: Keyword.get(unquote(@node_config), :label)
      def schema_type, do: Keyword.get(unquote(@node_config), :type)
      def schema_icon, do: Keyword.get(unquote(@node_config), :icon)
      def schema_description, do: Keyword.get(unquote(@node_config), :description)
      def schema_externals, do: unquote(@external_fields)
      def allow_image_upload?, do: Keyword.get(unquote(@node_config), :allow_image_upload, false)
      def hidden?, do: Keyword.get(unquote(@node_config), :hidden, false)

      # Field configs
      def __schema__(:field_config), do: unquote(@field_config)
      def __schema__(:node_config), do: unquote(@node_config)

      def __schema__(:sorted_fields),
        do:
          unquote(@field_config)
          |> Enum.reject(&is_nil(Map.get(&1, :sorted, nil)))
          |> Enum.sort_by(& &1.sorted)
          |> Enum.map(fn field ->
            {field.name, field.sorted}
          end)

      def __schema__(:field_templates),
        do:
          unquote(@field_config)
          |> Enum.map(fn field ->
            {field.name,
             [
               {:show, Map.get(field, :show_template)},
               {:edit, Map.get(field, :edit_template)},
               {:change, Map.get(field, :change_template)}
             ]}
          end)

      def __schema__(:hidden_fields),
        do:
          unquote(@field_config)
          |> Enum.map(fn field ->
            {field.name, Map.get(field, :hidden, false)}
          end)
    end
  end

  defmacro field_config(name, opts \\ []) do
    quote do
      Graph.Schema.__field__(__MODULE__, unquote(name), unquote(opts))
    end
  end

  defmacro node_config(name, value) do
    quote do
      Graph.Schema.__node__(__MODULE__, unquote(name), unquote(value))
    end
  end

  def __field__(module, name, opts) do
    config = %{name: name} |> Map.merge(opts |> Enum.into(%{}))

    Module.put_attribute(module, :field_config, config |> Macro.escape())

    if Keyword.get(opts |> Enum.into([]), :external, false) do
      dependency =
        if Keyword.get(opts |> Enum.into([]), :depends_on, false) do
          Keyword.get(opts |> Enum.into([]), :depends_on).__schema__(:field_config)
          |> Enum.find(&(&1.name == name))
          |> Enum.into([])
        else
          []
        end

      external_config = %{
        name: name,
        label: Keyword.get(dependency, :label, Keyword.get(opts |> Enum.into([]), :label)),
        example: Keyword.get(dependency, :example, Keyword.get(opts |> Enum.into([]), :example)),
        url: Keyword.get(dependency, :url, Keyword.get(opts |> Enum.into([]), :url))
      }

      Module.put_attribute(module, :external_fields, external_config |> Macro.escape())
    end
  end

  def __node__(module, name, value) do
    config = {name, value}
    Module.put_attribute(module, :node_config, config |> Macro.escape())
  end

  def validate_required_list(%Ecto.Changeset{changes: changes} = changeset, field) do
    unless Map.has_key?(changes, field) do
      changeset
      |> Ecto.Changeset.add_error(field, "is required")
    else
      Ecto.Changeset.validate_change(changeset, field, &required_list?(&1, &2))
    end
  end

  def fill_relation(%Ecto.Changeset{} = changeset, params, field) do
    unless Map.has_key?(params, field) do
      changeset
    else
      value = Map.get(params, field)

      cond do
        is_it_binary?(value) ->
          changeset
          |> Ecto.Changeset.put_change(field, Graph.Repo.get!(value))

        is_map(value) ->
          changeset
          |> Ecto.Changeset.put_change(field, value)

        true ->
          changeset
      end
    end
  end

  defp required_list?(current_field, nil), do: [{current_field, "is required"}]
  defp required_list?(current_field, ""), do: [{current_field, "is required"}]

  defp required_list?(current_field, value) when is_list(value) do
    unless value |> Enum.count() do
      [{current_field, "is required"}]
    else
      []
    end
  end

  defp required_list?(_, _), do: []

  defp is_it_binary?(""), do: nil
  defp is_it_binary?(nil), do: nil
  defp is_it_binary?(value) when is_binary(value), do: true
  defp is_it_binary?(_), do: false
end
