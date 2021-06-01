defmodule FrontendWeb.ApiView do
  use FrontendWeb, :view

  def render("show.json", %{result: item}) do
    %{
      status: "ok",
      item: %{
        type: item.__struct__.__schema__(:source),
        attributes:
          item
          |> Map.from_struct()
          |> Enum.map(fn {k, v} ->
            %{key: k, value: v}
          end)
      }
    }
  end

  def render("results.json", %{result: {:ok, %{"hits" => hits}}}) do
    %{
      status: "ok",
      items:
        hits
        |> Enum.map(&parse_hit/1)
    }
  end

  def render("query.json", %{values: values}) do
    %{status: "ok", uids: values}
  end

  def render("query.json", _) do
    %{status: "error", uids: []}
  end

  def render("result.json", %{result: {:ok, item}}) do
    {:ok, item} = Graph.Repo.get_new(item.uid)

    %{status: "ok", item: item}
  end

  def render("result.json", %{result: {:error, _} = _e}) do
    %{status: "error", message: "Couldn't update/create item"}
  end

  defp parse_hit(hit) do
    hit
    |> Map.keys()
    |> Enum.reduce(%{}, fn key, acc ->
      key
      |> String.split("@")
      |> case do
        [new_key, lang] ->
          Map.put(
            acc,
            new_key,
            [%{"value" => Map.get(hit, key), "language" => lang} | Map.get(acc, new_key, [])]
          )

        _ ->
          Map.put(acc, key, Map.get(hit, key))
      end
    end)
  end
end
