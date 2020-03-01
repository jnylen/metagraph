defmodule FrontendWeb.AjaxView do
  @moduledoc false

  use FrontendWeb, :view

  def render("save.json", %{response: {:ok, _}}) do
    %{
      status: "ok"
    }
  end

  def render("save.json", _) do
    %{
      status: "error"
    }
  end

  def render("find_edges.json", %{result: result}) do
    result
    |> Enum.map(fn edge ->
      %{
        "dgraph.type" => [edge.__struct__.__schema__(:source)],
        "best_label" =>
          Map.get(
            FrontendWeb.ItemHelpers.get_lang(Map.get(edge, :label, []), "sv-SE"),
            :value,
            "Unknown"
          ),
        "label" => edge.label,
        "uid" => edge.uid
      }
    end)
  end
end
