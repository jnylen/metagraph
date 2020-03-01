defmodule FrontendWeb.ItemLive.RelationTag do
  use Phoenix.LiveComponent

  def render(assigns),
    do: FrontendWeb.NewItemView.render("show/predicate/relations/_tag.html", assigns)
end
