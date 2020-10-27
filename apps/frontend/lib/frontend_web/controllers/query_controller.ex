defmodule FrontendWeb.QueryController do
  use FrontendWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", page_title: "Query")
  end

  def query(conn, %{"query" => query}) do
    response = query
              |> Absinthe.run(Api.Schema)

    conn
    |> render("query.json", %{query: response})
  end
end
