defmodule Api.Custom.ItemView do
  use Api, :view

  def render("result.json", %{result: {:ok, item}}) do
    {:ok, item} = Graph.Repo.get_new(item.uid)

    %{status: "ok", item: item}
  end

  def render("result.json", %{result: {:error, _} = _e}) do
    %{status: "error", message: "Couldn't update/create item"}
  end
end
