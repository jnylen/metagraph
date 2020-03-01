defmodule FrontendWeb.GraphHelper do
  def set_current_user(conn, user_id) do
    user = Database.get_user(user_id)

    cond do
      current_user = user && user ->
        conn
        |> Phoenix.LiveView.assign(:current_user, current_user)
        |> Phoenix.LiveView.assign(:user_signed_in?, true)

      true ->
        conn
        |> Phoenix.LiveView.assign(:current_user, nil)
        |> Phoenix.LiveView.assign(:user_signed_in?, false)
    end
  end

  def get_module(name) do
    Graph.Repo.meta()
    |> Map.get(:lookup)
    |> Map.get(name)
  end

  def set_language(struct, _key, "", _), do: struct
  def set_language(struct, _key, nil, _), do: struct

  def set_language(struct, key, value, language) do
    struct
    |> Map.put(key, [%Dlex.Lang{language: language, value: value}])
  end
end
