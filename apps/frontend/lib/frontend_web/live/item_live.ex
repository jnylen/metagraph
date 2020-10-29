defmodule FrontendWeb.ItemLive do
  use FrontendWeb, :live_view
  import FrontendWeb.TemplateHelper
  import FrontendWeb.GraphHelper
  import Ecto.Query

  def mount(_params, %{"current_user_id" => user_id}, socket) do
    {:ok, assign_new(socket, :current_user, fn -> Database.get_user(user_id) end)}
  end

  @doc """
    Handle a mount of a websocket for `new`
  """
  def mount(_params, %{"current_user_id" => cuid}, %{assigns: %{live_action: :new}} = socket) do
    new_socket =
      socket
      |> set_current_user(cuid)
      |> assign(types: types(), languages: Graph.Struct.Language.all())
      |> assign(:page_title, page_title("Create an item"))

    {:ok, new_socket}
  end

  def mount(
        %{"chosen_type" => chosen_type},
        %{"current_user_id" => cuid},
        %{assigns: %{live_action: :new_item}} = socket
      ) do
    type = types() |> Enum.find(&(&1.id == chosen_type))

    new_socket =
      socket
      |> set_current_user(cuid)
      |> assign(:chosen_type, chosen_type)
      |> assign(:chosen_type_data, type)
      |> assign(:form_data, %{})
      |> assign(:languages, Graph.Struct.Language.all())
      |> assign(:page_title, page_title("Create an #{chosen_type}"))
      |> assign(:item, get_module(chosen_type).__struct__)
      |> assign(:changeset, get_module(chosen_type).changeset(get_module(chosen_type).__struct__))

    {:ok, new_socket}
  end

  @doc """
    Handle a mount of a websocket for `show`
  """
  def mount(
        %{"uid" => uid},
        _session,
        %{assigns: %{live_action: :show} = assigns} = socket
      ) do
    {:ok, item} = Graph.Repo.get(uid)

    if is_map(item) do
      types =
        FrontendWeb.ItemHelpers.get_predicate_types(
          item.__struct__,
          item.__struct__.__schema__(:alter),
          item.__struct__.__schema__(:field_config)
        )
        |> Enum.sort_by(fn i -> item.__struct__.__schema__(:sorted_fields)[i["name"]] end)

      sections = FrontendWeb.ItemHelpers.get_sections(types)

      new_socket =
        socket
        |> assign(:item, item)
        |> assign(:sections, sections)
        |> assign(:types, types)
        |> assign(:page_title, page_title("Item"))
        |> assign(:current_user, Map.get(assigns, :current_user))

      {:ok, new_socket}
    else
      raise Frontend.Error.NotFound, message: "Item is not found"
    end
  end

  @doc """
    Handle a mount of a websocket for `edit`
  """
  def mount(
        %{"uid" => uid},
        %{"current_user_id" => cuid},
        %{assigns: %{live_action: :edit}} = socket
      ) do
    {:ok, item} = Graph.Repo.get(uid)

    types =
      FrontendWeb.ItemHelpers.get_predicate_types(
        item.__struct__,
        item.__struct__.__schema__(:alter),
        item.__struct__.__schema__(:field_config)
      )
      |> Enum.sort_by(fn i -> item.__struct__.__schema__(:sorted_fields)[i["name"]] end)

    sections = FrontendWeb.ItemHelpers.get_sections(types)

    new_socket =
      socket
      |> set_current_user(cuid)
      |> assign(:item, item)
      |> assign(:sections, sections)
      |> assign(:types, types)
      |> assign(:page_title, page_title("Edit item"))

    {:ok, new_socket}
  end

  @doc """
    Handle a mount of a websocket for `changes`
  """
  def mount(
        %{"uid" => uid} = params,
        _session,
        %{assigns: %{live_action: :changes}} = socket
      ) do
    {:ok, item} = Graph.Repo.get(uid)

    changes =
      Database.Media.Change
      |> where(subject: ^item.uid)
      |> order_by(desc: :inserted_at)
      |> preload(:user)
      |> Database.Repo.paginate(params)

    new_socket =
      socket
      |> assign(:item, item)
      |> assign(:changes, changes)
      |> assign(:page_title, page_title("Changes"))

    {:ok, new_socket}
  end

  @doc """
    Render a view form
  """
  def render(%{live_action: :new_item, chosen_type: value} = assigns) when not is_nil(value) do
    # type = assigns.types |> Enum.find(&(&1.id == assigns.chosen_type))

    Phoenix.View.render(
      FrontendWeb.NewItemView,
      "new_item.html",
      assigns
    )
  end

  @doc """
    Render a list of item types
  """
  def render(%{live_action: :new} = assigns),
    do: FrontendWeb.NewItemView.render("new.html", assigns)

  @doc """
    Render an item
  """
  def render(%{live_action: :show} = assigns),
    do: FrontendWeb.NewItemView.render("show.html", assigns)

  @doc """
    Render an edit
  """
  def render(%{live_action: :edit} = assigns),
    do: FrontendWeb.NewItemView.render("edit.html", assigns)

  @doc """
    Render changes
  """
  def render(%{live_action: :changes} = assigns),
    do: FrontendWeb.NewItemView.render("changes.html", assigns)

  @doc """
    Handle incoming params
  """
  def handle_params(%{"chosen_type" => chosen_type}, _uri, socket) do
    # new_socket =
    #   socket
    #   |> assign(:chosen_type, chosen_type)
    #   |> assign(:page_title, page_title("Create an #{chosen_type}"))
    #   |> assign(:item, get_module(chosen_type).__struct__)
    #   |> assign(:changeset, get_module(chosen_type).changeset(get_module(chosen_type).__struct__))

    {:noreply, socket}
  end

  def handle_params(_params, _uri, %{assigns: %{live_action: :edit}} = socket) do
    new_socket =
      socket
      |> assign(:changeset, socket.assigns.item.__struct__.changeset(socket.assigns.item, %{}))

    {:noreply, new_socket}
  end

  def handle_params(_, _, socket), do: {:noreply, socket}

  @doc """
    Handle an validation event (aka changed values)
  """

  def handle_event(
        "validate",
        %{"item" => params},
        %{assigns: %{item: %Ecto.Changeset{} = changeset}} = socket
      ) do
    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event(
        "validate",
        %{"item" => params} = e,
        socket
      ) do
    changeset =
      socket.assigns.item
      |> socket.assigns.item.__struct__.changeset(params)

    {:noreply, assign(socket, changeset: changeset, form_data: Map.get(e, "item", %{}))}
  end

  @doc """
    Handle an creation event
  """
  def handle_event("create", %{"item" => _params}, socket) do
    # Create item
    socket.assigns.changeset
    |> Editor.create(socket.assigns.current_user)
    |> case do
      {:ok, item} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item created successfully.")
         |> redirect(to: "/uid/#{item.uid}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Couldn't create the item.")
          |> assign(changeset: changeset)
        }
    end

    # {:noreply, assign(socket, changeset: socket.assigns.changeset)}
  end

  # Update item
  def handle_event("update", %{"item" => _params}, socket) do
    socket.assigns.item
    |> Editor.update(socket.assigns.changeset, socket.assigns.current_user)
    |> case do
      {:ok, item} ->
        {:noreply,
         socket
         |> put_flash(:info, "Item updated successfully.")
         |> redirect(to: "/uid/#{item.uid}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Couldn't update the item.")
          |> assign(changeset: changeset)
        }
    end
  end

  def path(path), do: path

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
