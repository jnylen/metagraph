defmodule Api.Schema.Person do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.Person, as: PersonResolver

  object :person do
    field :uid, :string
    field :label, list_of(:language)
    field :description, list_of(:language)
    field :website, :string
    field :birth_day, :date
    field :death_day, :date
  end

  object :person_queries do
    field :people, list_of(:person) do
      resolve &PersonResolver.list/3
    end

    field :person, :person do
      arg :uid, non_null(:string)
      resolve &PersonResolver.find/3
    end
  end
end
