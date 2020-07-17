defmodule Api.Resolvers.Film do
  use Api.Resolver

  def struct_name, do: Graph.Film
end
