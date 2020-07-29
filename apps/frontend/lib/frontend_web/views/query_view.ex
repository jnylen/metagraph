defmodule FrontendWeb.QueryView do
  use FrontendWeb, :view

  def render("query.json", %{query: {:ok, %{data: response}}}),
    do: %{status: "ok", response: response}

  def render("query.json", %{query: {:ok, %{errors: responses}}}),
    do: %{status: "error", response: responses}

  def render("query.json", %{query: {:error, response}}),
    do: %{status: "error", response: response}
end
