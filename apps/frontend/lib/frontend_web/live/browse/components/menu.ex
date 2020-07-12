defmodule FrontendWeb.BrowseLive.Menu do
  use FrontendWeb, :live_component

  def active_link?(link, active_link) do
    default_classes = "px-4 py-2 mr-3"

    if link != active_link do
      default_classes
    else
      "#{default_classes} rounded-lg bg-indigo-100 text-indigo-900"
    end
  end
end
