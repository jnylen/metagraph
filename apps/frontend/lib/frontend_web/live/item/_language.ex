defmodule FrontendWeb.ItemLive.Language do
  use FrontendWeb, :live_component

  def render(assigns),
    do:
      FrontendWeb.NewItemView.render(
        "#{assigns.folder}/predicate/special/#{assigns.using}_item.html",
        assigns
      )
end
