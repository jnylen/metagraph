defmodule FrontendWeb.ItemLive.PredicateHeader do
  use Phoenix.LiveComponent

  def render(assigns),
    do: FrontendWeb.NewItemView.render("#{assigns.folder}/predicate/_header.html", assigns)
end
