defmodule FrontendWeb.ItemLive.Change do
  use FrontendWeb, :live_component

  def render(assigns),
    do: FrontendWeb.NewItemView.render("changes/_#{assigns.change.action}.html", assigns)
end
