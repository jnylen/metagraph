defmodule Api.Schema.QueryBuilder do
  @moduledoc """
  A helper class that build a valid Dgraph query based on Absinthe project info
  """
  alias Absinthe.Blueprint.Document.Field
  alias Absinthe.Blueprint.Input.Argument

  alias Api.Schema.Query
  alias Api.Schema.ParserState, as: State

  @valid_languages Graph.Struct.Language.all() |> Enum.map(& &1.code)
  @fallback_language "en-US"

  @doc """
  Converts the given Absinthe Info into a valid Dgraph query based on the given Vertex.

  The given `language` is used to translate every string
  """
  def build_query(vertex, info, language \\ @fallback_language) do
    build_query_with_fields(vertex, Absinthe.Resolution.project(info), language)
    |> IO.inspect()
  end

  @doc """
  Converts the given Absinthe Field list into a valid Dgraph query based on the given Vertex
  """
  def build_query_with_fields(vertex, fields, language \\ @fallback_language) do
    fields
    |> map_fields(vertex, language)
    |> Query.stringify_fields()
  end

  # Get the fields info and translate it into a common "schema" called `Api.Schema.ParserState`
  defp map_fields(fields, vertex, language) when is_list(fields) do
    fields
    |> Enum.map(&map_field(vertex, &1, language))
    |> Enum.reject(&is_nil(&1.name))
  end

  # Convert the given field metadata into `Api.Schema.ParserState`
  defp map_field(
         vertex,
         %Field{name: name, selections: childs, arguments: args},
         language
       ) do
    field_name = name_to_atom(name)
    translatable? = is_translatable(vertex, field_name)

    language =
      resolve_language(Argument.value_map(args) |> IO.inspect() |> Map.get(:language, language))

    %State{
      name: resolve_name(vertex, field_name, translatable?, language),
      func: resolve_func_args(vertex, args, field_name),
      childs: resolve_childs(vertex, field_name, childs, language),
      resolve: field_resolve(vertex, field_name)
    }
  end

  # TODO: Is better make this on the Field struct properties?
  defp is_translatable(vertex, name) do
    vertex.__schema__(:field_types)
    |> Enum.reject(fn {atom, _, _} ->
      atom != name
    end)
    |> List.first()
    |> case do
      {_, _, :lang} ->
        true

      _ ->
        false
    end
  end

  # Check the given language is a valid one
  defp resolve_language(language) when language not in @valid_languages, do: @fallback_language
  defp resolve_language(language), do: language

  # Check if the field is translatable (is string) and apply the language,
  # If not just alias the name with the real field name
  # If don't exist return nil (and don't process)
  defp resolve_name(vertex, name, is_translatable?, language) do
    on_fields? = name in vertex.__schema__(:fields)

    cond do
      on_fields? and is_translatable? ->
        "#{name}: #{vertex.__schema__(:field, name)}@#{language}:."

      on_fields? ->
        "#{name}: #{vertex.__schema__(:field, name)}"

      name == :uid ->
        "#{name}"

      true ->
        nil
    end
  end

  # Get the function arguments, based on the Absinthe Input, ignore non-valid ones
  defp resolve_func_args(_vertex, [], _field_name), do: nil

  defp resolve_func_args(vertex, args, field_name) do
    # TODO: Hanlde input_object argument (nested arguments)

    Argument.value_map(args)
    |> Map.delete(:language)
    |> Map.to_list()
    |> Enum.map(fn {arg_name, value} ->
      vertex.__schema__(:argument, field_name, arg_name, value)
    end)
    |> Enum.reject(&is_nil/1)
  end

  # Resolve the field childs
  defp resolve_childs(_vertex, _name, [], _language), do: []

  defp resolve_childs(vertex, field_name, childs, language) do
    vertex.__schema__(:fields_data)
    |> Enum.reject(fn %Dlex.Field{name: name, type: type} ->
      name != field_name or not Enum.member?([:reverse_relation, :relation, :relations], type)
    end)
    |> List.first()
    |> IO.inspect()
    |> case do
      %Dlex.Field{} = field ->
        Keyword.get(field.opts, :model, Keyword.get(field.opts, :models, nil))
        |> case do
          nil ->
            []

          [_] = models ->
            map_fields(childs, models |> List.first(), language)

          model ->
            map_fields(childs, model, language)
        end

      _ ->
        []
    end
  end

  defp field_resolve(vertex, field_name) do
    # vertex.__schema__(:resolve, field_name)

    nil
  end

  # Convert the name into a valid atom
  defp name_to_atom(name) do
    Regex.replace(~r/([A-Z])/, name, "_\\0")
    |> String.downcase()
    |> String.to_existing_atom()
  end
end
