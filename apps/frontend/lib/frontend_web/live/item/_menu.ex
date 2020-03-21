defmodule FrontendWeb.ItemLive.Menu do
  use FrontendWeb, :live_component

  def render(assigns), do: FrontendWeb.NewItemView.render("shared/_menu.html", assigns)
end
