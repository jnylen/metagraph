defmodule FrontendWeb.ItemLive.Domain do
  use FrontendWeb, :live_component

  def render(assigns) do
    cond do
      Map.get(assigns, :template, false) ->
        try do
          FrontendWeb.NewItemView.render(
            "#{assigns.folder}/domain/#{assigns.template}.html",
            assigns
          )
        rescue
          _ ->
            assigns
            |> Map.delete(:template)
            |> render()
        end

      Map.get(assigns, :type, false) ->
        try do
          FrontendWeb.NewItemView.render(
            "#{assigns.folder}/domain/#{assigns.type}.html",
            assigns
          )
        rescue
          _ ->
            assigns
            |> Map.delete(:type)
            |> render()
        end

      true ->
        FrontendWeb.NewItemView.render(
          "#{assigns.folder}/domain/_default.html",
          assigns
        )
    end
  end
end
