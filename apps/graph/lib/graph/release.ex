defmodule Graph.Release do
  @app :dlex

  def alter_schema do
    repo().alter_schema()
  end

  defp repo do
    Application.load(@app)
    Application.fetch_env!(@app, :repo)
  end

  def setup_meili do
    Meilisearch.Index.create("items", primary_key: "uid")
  end

  def reindex_meili do
    statement = [
      "{ query(func: type(film)) { uid type : dgraph.type label : common.label@* description : common.description@* } }"
    ]

    with {:ok, %{"query" => nodes}} <- Dlex.query(Graph.Repo, statement) do
      Meilisearch.Document.add_or_replace("items", nodes)
    end
  end
end
