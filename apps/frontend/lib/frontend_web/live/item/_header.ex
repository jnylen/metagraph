defmodule FrontendWeb.ItemLive.Header do
  use Phoenix.LiveComponent

  def render(assigns), do: FrontendWeb.NewItemView.render("shared/_header.html", assigns)
end
