defmodule FrontendWeb.SearchResultLive do
  use FrontendWeb, :component
  import FrontendWeb.ItemHelpers

  def render(assigns) do
    ~H"""
    <li class="bg-white w-1/2 mx-auto shadow overflow-hidden sm:rounded-md">
      <%= live_patch class: "block hover:bg-gray-50", to: Routes.item_path(Endpoint, :show, Map.get(@item, "uid")), replace: true do %>
        <div class="px-4 py-4 sm:px-6 flex items-center justify-between">
          <div class="">
              <p class="text-sm font-medium text-indigo-600 truncate">
                <%= Map.get(get_lang(Map.get(@item, "label", []), "sv-SE"), "value", "Unknown") %>
              </p>
              <p class="text-sm font-medium text-gray-600 truncate">
                  <%= Map.get(get_lang(Map.get(@item, "description", []), "sv-SE"), "value", "") %>
              </p>
          </div>
          <div class="ml-2 flex-shrink-0 flex">
            <p class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
              <%= get_type(@item) %>
            </p>
          </div>
        </div>
      <% end %>
    </li>
    """
  end
end
