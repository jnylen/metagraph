defmodule FrontendWeb.BrowseLive.Data do
  use FrontendWeb, :live_component

  def update(assigns, socket) do
    {:ok, %{"queries" => items}} =
      assigns
      |> Map.get(:type)
      |> Map.get(:model)
      |> Graph.Repo.paginate(nil)

    {:ok, assign(socket, type: assigns.type, items: items)}
  end
end
