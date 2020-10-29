defmodule FrontendWeb.BrowseLive.Data do
  use FrontendWeb, :live_component
  use Scrivener.HTML

  def update(assigns, socket) do
    scrivener =
      Graph.PaginateQuery.for_model(
        assigns
        |> Map.get(:type)
        |> Map.get(:model)
      )
      |> Graph.PaginateQuery.paginate(assigns)

    {:ok,
     assign(socket, type: assigns.type, scrivener: scrivener, current_user: assigns.current_user)}
  end
end
