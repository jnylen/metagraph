defmodule FrontendWeb.ItemLive.MediatorItem do
  use FrontendWeb, :live_component

  def render(%{value: value} = assigns),
    do: FrontendWeb.NewItemView.render("show/predicate/_mediator_item.html", assigns)
end
