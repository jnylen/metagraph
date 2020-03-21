defmodule FrontendWeb.BrowseLive do
  use FrontendWeb, :live_view
  import FrontendWeb.TemplateHelper
  import FrontendWeb.GraphHelper
  import Ecto.Query

  @doc """
    Handle a mount of a websocket for `index`
  """

  def mount(
        _params,
        _session,
        %{assigns: %{live_action: :index}} = socket
      ) do
    new_socket =
      socket
      |> assign(:types, types(false))
      |> assign(:page_title, page_title("Browse"))

    {:ok, new_socket}
  end

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
