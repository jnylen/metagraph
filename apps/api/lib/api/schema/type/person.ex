defmodule Api.Schema.Type.Person do
  use Absinthe.Schema.Notation

  object :person do
    field(:uid, non_null(:string))

    field :label, :string do
      arg(:language, :string)
    end

    field :description, :string do
      arg(:language, :string)
    end

    field(:website, :string)
    field(:birth_day, :date)
    field(:death_day, :date)
    # field(:bloodtype, :bloodtype)
    field(:weight, :integer)
    field(:height, :integer)
    field(:themoviedb_id, :integer)
    field(:imdb_id, :string)
    field(:freebase_id, :string)
    field(:wikidata_id, :string)
    field(:performances, list_of(:performance))
  end

  object :person_queries do
    field :person, :person do
      arg(:uid, non_null(:string))

      resolve(&Api.Schema.Query.get(&1, &2, Graph.Person))
    end

    field :people, list_of(:person) do
      arg(:offset, :integer)
      arg(:first, :string)
      arg(:orderasc, :string)
      arg(:orderdesc, :string)

      resolve(&Api.Schema.Query.all(&1, &2, Graph.Person))
    end
  end
end
