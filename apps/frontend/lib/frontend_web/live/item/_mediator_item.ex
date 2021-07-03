defmodule FrontendWeb.ItemLive.MediatorItem do
  use FrontendWeb, :live_component

  def render(%{value: value, component_view: component_view} = assigns),
    do: FrontendWeb.NewItemView.render("show/predicate/#{component_view}.html", assigns)
end
