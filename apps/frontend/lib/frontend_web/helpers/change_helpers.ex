defmodule FrontendWeb.ChangeHelpers do
  # TODO: Return a template for each variant of addition,
  # Relations etc

  # TODO: Grab all uids found in changes and then grab them.
  # To be able to return a template for that uid type.

  # TODO: Add a external link system for predicates.

  def remove_blanks!(nil, _), do: []

  def remove_blanks!(map, graph) do
    map
    |> IO.inspect()
    |> Enum.into([])
    |> Enum.map(fn change ->
      change
      |> case do
        {_key, %{"changed" => _, "value" => nil}} ->
          nil

        {_key, %{"changed" => _, "value" => []}} ->
          nil

        {key, %{"changed" => _, "value" => %{"uid" => _}} = changed_map} ->
          {key,
           changed_map
           |> Map.put(
             "value",
             Map.get(changed_map, "value", nil)
           )}

        {_key, %{"changed" => _, "value" => %{}}} ->
          nil

        {key, %{"changed" => _, "added" => [%{"uid" => _} | _]} = changed_map} ->
          {key,
           changed_map
           |> Map.put(
             "value",
             Map.get(changed_map, "added", nil)
           )}

        #  {key,
        #  changed_map
        #  |> Map.put(
        #    "value",
        #    Map.get(graph, key |> String.to_existing_atom(), Map.get(changed_map, "added", nil))
        #  )}

        val ->
          val
      end
    end)
    |> Enum.reject(&is_nil/1)
  end
end
