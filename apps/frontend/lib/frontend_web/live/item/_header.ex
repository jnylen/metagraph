defmodule FrontendWeb.ItemLive.Header do
  use FrontendWeb, :live_component

  def render(assigns), do: FrontendWeb.NewItemView.render("shared/_header.html", assigns)
end
