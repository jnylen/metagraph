defmodule Api.Schema.Query do
  def query_template(params, resolution, node) do
    query =
      Api.Schema.QueryBuilder.build_query(node, resolution)
      |> into_graphql

    # Filterize
    filters = params |> filterize()

    filter_type =
      case Map.get(params, :type) do
        nil -> ""
        type -> "type(\"#{type}\")"
      end

    """
    {
      results(#{func?(filters)}#{
      [filter_type, filters |> prettify_filters()]
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.join(", ")
    }) {
        #{query |> Enum.join("\n")}
      }
    }
    """
    |> IO.inspect()
  end

  def get(params, resolution, node) do
    statement = query_template(params, resolution, node)

    with {:ok, %{"results" => nodes}} <- Graph.Repo.all(statement) do
      case nodes do
        [%{"uid" => _} = map] when map_size(map) <= 2 ->
          {:ok, nil}

        [map] ->
          {:ok, atomize(map)}
      end
    end
  end

  def all(params, resolution, node) do
    statement =
      query_template(params |> Map.put_new(:type, node.__schema__(:source)), resolution, node)

    with {:ok, %{"results" => nodes}} <- Graph.Repo.all(statement) do
      nodes |> IO.inspect()

      {:ok, atomize(nodes)}
    end
  end

  def stringify_fields(list) do
    list
  end

  defp into_graphql([]), do: []

  defp into_graphql([state | states]) do
    [graphql_element(state) | into_graphql(states)]
  end

  defp graphql_element(%{childs: [], name: name}), do: name

  defp graphql_element(%{childs: childs, name: name}) do
    """
      #{name} {
        #{childs |> into_graphql |> Enum.join("\n")}
      }
    """
  end

  defp filterize(map) when is_map(map), do: map |> Enum.map(&Tuple.to_list/1) |> filterize()

  defp filterize([]), do: []

  defp filterize([[:uid, value] | params]) when is_bitstring(value),
    do: [{"func", "uid(#{value})"} | filterize(params)]

  defp filterize([[:uid, value] | params]) when is_list(value),
    do: [{"func", "uid(#{value |> Enum.join(", ")})"} | filterize(params)]

  defp filterize([[:type, value] | params]) when is_bitstring(value),
    do: [{"func", nil} | filterize(params)]

  defp filterize([[:type, value] | params]) when is_list(value),
    do: [{"func", nil} | filterize(params)]

  defp filterize([[:offset, value] | params]) when is_integer(value),
    do: [{"sort", "offset: #{value}"} | filterize(params)]

  defp filterize([[:first, value] | params]) when is_bitstring(value),
    do: [{"sort", "first: #{value}"} | filterize(params)]

  defp filterize([[:orderasc, value] | params]) when is_bitstring(value),
    do: [{"sort", "orderasc: #{value}"} | filterize(params)]

  defp filterize([[:orderdesc, value] | params]) when is_bitstring(value),
    do: [{"sort", "orderdesc: #{value}"} | filterize(params)]

  defp filterize([_ | params]), do: filterize(params)

  defp atomize(string_key_map) when is_map(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {atomize_key?(key), atomize(val)}
  end

  defp func?(list) when is_list(list) do
    list
    |> Enum.map(fn {type, _} -> type end)
    |> Enum.member?("func")
    |> case do
      true -> "func: "
      _ -> ""
    end
  end

  defp prettify_filters(list) when is_list(list) do
    list
    |> Enum.map(fn {_, value} -> value end)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(", ")
  end

  defp atomize(string_key_list) when is_list(string_key_list) do
    string_key_list
    |> Enum.map(&atomize/1)
  end

  defp atomize(value), do: value

  defp atomize_key?(key) when is_atom(key), do: key

  defp atomize_key?(key) when is_bitstring(key) do
    key
    |> String.to_existing_atom()
  rescue
    _ -> key
  end
end
