defmodule FrontendWeb.ItemLive.Language do
  use FrontendWeb, :live_component

  def render(assigns),
    do:
      FrontendWeb.NewItemView.render(
        "#{assigns.folder}/predicate/special/lang_#{assigns.type}_item.html",
        assigns
      )
end
