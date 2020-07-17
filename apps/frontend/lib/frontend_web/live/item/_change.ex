defmodule FrontendWeb.ItemLive.Change do
  use FrontendWeb, :live_component

  def render(assigns),
    do: FrontendWeb.NewItemView.render("changes/_#{assigns.item.action}.html", assigns)
end
