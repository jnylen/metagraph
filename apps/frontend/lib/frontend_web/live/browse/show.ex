defmodule FrontendWeb.BrowseLive.Show do
  use FrontendWeb, :live_view
  import FrontendWeb.TemplateHelper
  import FrontendWeb.GraphHelper
  import Ecto.Query

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    {:ok, assign_new(socket, :current_user, fn -> Database.get_user(user_id) end)}
  end

  @doc """
    Handle a mount of a websocket for `index`
  """
  def mount(
        %{"type" => type} = params,
        _session,
        %{assigns: %{live_action: :show} = assigns} = socket
      ) do
    type = types(false) |> Enum.find(&(&1.id == type))

    new_socket =
      socket
      |> assign(:type, type)
      |> assign(:menu, Map.get(params, "menu", "data"))
      |> assign(:page_title, page_title("Browse #{Map.get(type, :label)}"))
      |> assign(:current_user, Map.get(assigns, :current_user))
      |> assign(:page, Map.get(params, "page"))

    {:ok, new_socket}
  end

  def handle_params(%{"menu" => menu, "type" => type}, _uri, socket) do
    {:noreply, assign(socket, menu: menu, type: types(false) |> Enum.find(&(&1.id == type)))}
  end

  def handle_params(%{"type" => type}, _uri, socket) do
    {:noreply, assign(socket, type: types(false) |> Enum.find(&(&1.id == type)))}
  end

  def menu_component("data"), do: FrontendWeb.BrowseLive.Data
  def menu_component("queries"), do: FrontendWeb.BrowseLive.Queries
  def menu_component("schema"), do: FrontendWeb.BrowseLive.Schema
  def menu_component(_), do: nil

  # all valid item types
  defp types(_hide \\ true)

  defp types(true) do
    Graph.Repo.meta()
    |> Map.get(:modules, [])
    |> Enum.reject(& &1.hidden?)
    |> Enum.map(fn module ->
      %{
        model: module,
        label: module.schema_label,
        id: module.__schema__(:source),
        icon: module.schema_icon,
        description: module.schema_description,
        externals: module.schema_externals,
        type: module.schema_type,
        images: module.allow_image_upload?,
        hidden: module.hidden?
      }
    end)
  end

  defp types(false) do
    Graph.Repo.meta()
    |> Map.get(:modules, [])
    |> Enum.map(fn module ->
      %{
        model: module,
        label: module.schema_label,
        id: module.__schema__(:source),
        icon: module.schema_icon,
        description: module.schema_description,
        externals: module.schema_externals,
        type: module.schema_type,
        images: module.allow_image_upload?,
        hidden: module.hidden?
      }
    end)
  end
end
