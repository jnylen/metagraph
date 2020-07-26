defmodule Graph.Release do
  @app :dlex

  def alter_schema do
    repo().alter_schema()
  end

  defp repo do
    Application.load(@app)
    Application.fetch_env!(@app, :repo)
  end
end
