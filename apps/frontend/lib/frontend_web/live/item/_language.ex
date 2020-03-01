defmodule FrontendWeb.ItemLive.Language do
  use Phoenix.LiveComponent

  def render(assigns),
    do:
      FrontendWeb.NewItemView.render(
        "#{assigns.folder}/predicate/special/lang_#{assigns.type}_item.html",
        assigns
      )
end
