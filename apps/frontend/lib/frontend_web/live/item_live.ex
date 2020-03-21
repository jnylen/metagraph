defmodule FrontendWeb.ItemLive do
  use Phoenix.LiveView
  import FrontendWeb.TemplateHelper
  import FrontendWeb.GraphHelper
  import Ecto.Query

  @doc """
    Handle a mount of a websocket for `new`
  """
  def mount(_params, %{"current_user_id" => cuid}, %{assigns: %{live_view_action: :new}} = socket) do
    new_socket =
      socket
      |> set_current_user(cuid)
      |> assign(types: types(), languages: Graph.Struct.Language.all())
      |> assign(:page_title, page_title("Create an item"))

    {:ok, new_socket}
  end

  @doc """
    Handle a mount of a websocket for `show`
  """
  def mount(
        %{"uid" => uid},
        _session,
        %{assigns: %{live_view_action: :show}} = socket
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
      |> assign(:item, item)
      |> assign(:sections, sections)
      |> assign(:types, types)
      |> assign(:page_title, page_title("Item"))

    {:ok, new_socket}
  end

  @doc """
    Handle a mount of a websocket for `edit`
  """
  def mount(
        %{"uid" => uid},
        %{"current_user_id" => cuid},
        %{assigns: %{live_view_action: :edit}} = socket
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
        %{assigns: %{live_view_action: :changes}} = socket
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
    Handle a mount of a websocket for `index`
  """
  def mount(
        %{"type" => type} = params,
        _session,
        %{assigns: %{live_view_action: :index}} = socket
      ) do
    type = types(false) |> Enum.find(&(&1.id == type))

    new_socket =
      socket
      |> assign(:type, type)
      |> assign(:menu, Map.get(params, "menu", "index"))
      |> assign(:page_title, page_title("Browse #{Map.get(type, :label)}"))

    {:ok, new_socket}
  end

  def mount(
        _params,
        _session,
        %{assigns: %{live_view_action: :index}} = socket
      ) do
    new_socket =
      socket
      |> assign(:types, types(false))
      |> assign(:page_title, page_title("Browse"))

    {:ok, new_socket}
  end

  @doc """
    Render a view form
  """
  def render(%{live_view_action: :new, chosen_type: value} = assigns) when not is_nil(value) do
    type = assigns.types |> Enum.find(&(&1.id == assigns.chosen_type))

    FrontendWeb.NewItemView.render("new/form.html", assigns |> Map.put(:chosen_type, type))
  end

  @doc """
    Render a list of item types
  """
  def render(%{live_view_action: :new} = assigns),
    do: FrontendWeb.NewItemView.render("new.html", assigns)

  @doc """
    Render an item
  """
  def render(%{live_view_action: :show} = assigns),
    do: FrontendWeb.NewItemView.render("show.html", assigns)

  @doc """
    Render an edit
  """
  def render(%{live_view_action: :edit} = assigns),
    do: FrontendWeb.NewItemView.render("edit.html", assigns)

  @doc """
    Render an item
  """
  def render(%{live_view_action: :index, type: _type} = assigns),
    do: FrontendWeb.NewItemView.render("browse.html", assigns)

  def render(%{live_view_action: :index} = assigns),
    do: FrontendWeb.NewItemView.render("index.html", assigns)

  @doc """
    Render changes
  """
  def render(%{live_view_action: :changes} = assigns),
    do: FrontendWeb.NewItemView.render("changes.html", assigns)

  @doc """
    Handle incoming params
  """
  def handle_params(%{"chosen_type" => chosen_type}, _uri, socket) do
    new_socket =
      socket
      |> assign(:chosen_type, chosen_type)
      |> assign(:trans, %{})
      |> assign(:page_title, page_title("Create an #{chosen_type}"))
      |> assign(:changeset, get_module(chosen_type).changeset(get_module(chosen_type).__struct__))

    {:noreply, new_socket}
  end

  def handle_params(_params, _uri, %{assigns: %{live_view_action: :edit}} = socket) do
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
        %{"item" => %{"type" => type} = params, "trans" => trans},
        socket
      ) do
    changeset =
      get_module(type).__struct__
      |> get_module(type).changeset(
        params
        |> set_language("label", trans["label"], trans["language"])
        |> set_language("description", trans["description"], trans["language"])
      )

    # |> Map.put(:action, :insert)

    {:noreply, assign(socket, trans: trans, changeset: changeset)}
  end

  @doc """
    Handle an validation event (aka changed values)
  """
  def handle_event(
        "validate",
        %{"item" => params},
        socket
      ) do
    changeset =
      socket.assigns.item
      |> socket.assigns.item.__struct__.changeset(params)
      |> IO.inspect()

    # |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
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
  end

  # Update item
  def handle_event("update", %{"item" => _params}, socket) do
    socket.assigns.changeset
    |> Editor.update(socket.assigns.current_user)
    |> case do
      {:ok, item} ->
        {:stop,
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
