defmodule FrontendWeb.ItemLive.Menu do
  use Phoenix.LiveComponent

  def render(assigns), do: FrontendWeb.NewItemView.render("shared/_menu.html", assigns)
end
