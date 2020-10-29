defmodule FrontendWeb.FeedController do
  use FrontendWeb, :controller

  import Ecto.Query

  def index(conn, params) do
    scrivener =
      Database.Media.Change
      |> order_by(desc: :inserted_at)
      |> preload(:user)
      |> Database.Repo.paginate(params)

    graphs =
      scrivener.entries
      |> Enum.map(& &1.subject)
      |> Graph.get_all()
      |> to_map()

    conn
    |> render("index.html",
      graphs: graphs,
      scrivener: scrivener,
      page_title: "Feed"
    )
  end

  defp to_map(graphs) when is_list(graphs) do
    graphs
    |> Enum.reduce(%{}, fn item, acc ->
      Map.put(acc, Map.get(item, :uid), item)
    end)
  end
end
