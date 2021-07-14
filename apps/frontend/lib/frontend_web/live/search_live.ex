defmodule FrontendWeb.SearchLive do
  use FrontendWeb, :live_view

  def render(%{live_action: :index} = assigns) do
    FrontendWeb.SearchView.render("index.html", assigns)
  end

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:results, [])
      |> assign(:fetching, Map.get(socket.assigns, :fetching, false))
    }
  end

  def handle_event("search", %{"value" => ""}, socket) do
    {
      :noreply,
      socket
      |> assign(:fetching, false)
      |> assign(:results, [])
    }
  end

  def handle_event("search", %{"value" => value}, socket) do
    {:ok, results} = Meilisearch.Search.search("items", value, [])

    {
      :noreply,
      socket
      |> assign(:fetching, false)
      |> assign(
        :results,
        results
        |> Map.get("hits", [])
        |> Enum.map(&parse_hit/1)
      )
    }
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
