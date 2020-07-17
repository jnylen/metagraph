defmodule Api.Resolvers.Person do
  use Api.Resolver

  def struct_name, do: Graph.Person
end
