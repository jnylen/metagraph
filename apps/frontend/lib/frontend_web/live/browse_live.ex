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
    types = types(false)
    {:ok, counts} = count_types(types)

    new_socket =
      socket
      |> assign(:types, types)
      |> assign(:counts, counts)
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

  defp count_types(types) do
    query = """
    {
      #{Enum.map(types, &count_type_query/1) |> Enum.join("\n")}
    }
    """

    Graph.Repo.all(query)
  end

  defp count_type_query(%{id: id}) do
    """
    #{id}(func: type("#{id}")) {
      count(uid)
    }
    """
  end
end
