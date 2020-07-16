defmodule Api.Resolvers.Genre do
  use Api.Resolver

  def struct_name, do: Graph.Media.Genre
end
