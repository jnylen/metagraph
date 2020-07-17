defmodule FrontendWeb.ChangeHelpers do
  # TODO: Return a template for each variant of addition,
  # Relations etc

  # TODO: Grab all uids found in changes and then grab them.
  # To be able to return a template for that uid type.

  # TODO: Add a external link system for predicates.

  def remove_blanks!(nil, _), do: []

  def remove_blanks!(map, graph) do
    map
    |> parse_items(graph)
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end

  defp parse_items([], _graph), do: []
  defp parse_items([item | items], graph) do

    [ parse_item(item, graph) | parse_items(items, graph)]
  end

  defp parse_item(%{"action" => "eq"}, _), do: nil
  defp parse_item(%{"value" => nil}, _), do: nil
  defp parse_item(%{"value" => []}, _), do: nil
  defp parse_item(%{"key" => "uid"}, _), do: nil
  defp parse_item(%{"action" => "diff", "key" => real_key, "value" => value} = map, _) when is_map(value) do
    for {key, val} <- value do
      %{
        "action" => key,
        "key" => real_key,
        "value" => val
      }
    end
  end

  defp parse_item(map, _), do: map
end
