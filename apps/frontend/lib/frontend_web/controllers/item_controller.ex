defmodule FrontendWeb.ItemController do
  use FrontendWeb, :controller
  import Ecto.Query

  def types do
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
        externals: module.schema_externals
      }
    end)
  end

  def valid_types do
    types() |> Enum.map(& &1.id)
  end

  @doc """
  Changes for an item
  """
  def changes(conn, %{"uid" => uid} = params) do
    # Get item
    uid
    |> Graph.Repo.get()
    |> case do
      {:ok, nil} ->
        conn
        |> put_flash(:error, "Item can not be found!")
        |> redirect(to: "/")

      {:ok, item} ->
        changes =
          Database.Media.Change
          |> where(subject: ^item.uid)
          |> order_by(desc: :inserted_at)
          |> preload(:user)
          |> Database.Repo.paginate(params)

        render(conn, "changes.html",
          page_title: "Changes",
          item: item,
          changes: changes
        )

      _ ->
        conn
        |> put_flash(:error, "Item can not be found!")
        |> redirect(to: "/")
    end
  end

  @doc """
  Item editor
  """
  def edit(conn, %{"uid" => uid}) do
    # Get item
    uid
    |> Graph.Repo.get()
    |> case do
      {:ok, nil} ->
        conn
        |> put_flash(:error, "Item can not be found!")
        |> redirect(to: "/")

      {:ok, item} ->
        types =
          FrontendWeb.ItemHelpers.get_predicate_types(
            item.__struct__,
            item.__struct__.__schema__(:alter),
            item.__struct__.__schema__(:field_config)
          )
          |> Enum.sort_by(fn i -> item.__struct__.__schema__(:sorted_fields)[i["name"]] end)

        sections = FrontendWeb.ItemHelpers.get_sections(types)

        render(conn, "edit.html",
          page_title: "Edit",
          item: item,
          changeset: item.__struct__.changeset(item),
          types: types,
          sections: sections,
          menu_items: sections
        )

      _ ->
        conn
        |> put_flash(:error, "Item can not be found!")
        |> redirect(to: "/")
    end
  end

  @doc """
  Update an item
  """
  def update(conn, %{"uid" => uid, "item" => changes} = _params) do
    Frontend.Editor.update(uid, changes, conn.assigns.current_user)
    |> case do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: Routes.item_path(conn, :edit, item.uid))

      {:error, _} ->
        conn
        |> put_flash(:error, "Couldn't update the item.")
        |> redirect(to: Routes.item_path(conn, :edit, uid))
    end
  end

  @doc """
  Item shower
  """
  def show(conn, %{"uid" => uid}) do
    # Get item
    uid
    |> Graph.Repo.get()
    |> case do
      {:ok, nil} ->
        conn
        |> put_flash(:error, "Item can not be found!")
        |> redirect(to: "/")

      {:ok, item} ->
        types =
          FrontendWeb.ItemHelpers.get_predicate_types(
            item.__struct__,
            item.__struct__.__schema__(:alter),
            item.__struct__.__schema__(:field_config)
          )
          |> Enum.sort_by(fn i -> item.__struct__.__schema__(:sorted_fields)[i["name"]] end)

        sections = FrontendWeb.ItemHelpers.get_sections(types)

        render(conn, "show.html",
          page_title: "Item",
          item: item,
          types: types,
          sections: sections,
          menu_items: sections
        )

      _ ->
        conn
        |> put_flash(:error, "Item can not be found!")
        |> redirect(to: "/")
    end
  end

  defp get_model([id]), do: get_model(id)

  defp get_model(id) do
    types
    |> Enum.find(fn type ->
      type.id == id
    end)
    |> Map.get(:model)
  end

  defp get_model(_), do: nil

  defp is_blank?(""), do: true
  defp is_blank?(nil), do: true

  defp is_blank?(string) do
    string
    |> String.trim()
    |> case do
      "" -> true
      _ -> false
    end
  end
end
