defmodule FrontendWeb.ItemLive.PredicateHeader do
  use FrontendWeb, :live_component

  def render(assigns),
    do: FrontendWeb.NewItemView.render("#{assigns.folder}/predicate/_header.html", assigns)
end
