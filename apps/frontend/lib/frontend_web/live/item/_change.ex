defmodule FrontendWeb.ItemLive.Change do
  use Phoenix.LiveComponent

  def render(assigns),
    do: FrontendWeb.NewItemView.render("changes/_#{assigns.change.action}.html", assigns)
end
