defmodule FrontendWeb.ItemLive.RelationTag do
  use FrontendWeb, :live_component

  def render(assigns),
    do: FrontendWeb.NewItemView.render("show/predicate/relations/_tag.html", assigns)
end
