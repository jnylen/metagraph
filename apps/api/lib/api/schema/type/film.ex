defmodule Api.Schema.Type.Film do
  use Absinthe.Schema.Notation

  object :film do
    field(:uid, non_null(:string))

    field :label, :string do
      arg(:language, :string)
    end

    field :description, :string do
      arg(:language, :string)
    end

    field(:website, :string)

    field(:budget, :integer)
    field(:revenue, :integer)

    field(:wikidata_id, :string)
    field(:imdb_id, :string)
    field(:freebase_id, :string)
    field(:themoviedb_id, :integer)

    field(:genre, list_of(:media_genre))
    field(:performances, list_of(:performance))
  end

  object :film_queries do
    field :film, :film do
      arg(:uid, non_null(:string))

      resolve(&Api.Schema.Query.get(&1, &2, Graph.Film))
    end

    field :films, list_of(:film) do
      arg(:offset, :integer)
      arg(:first, :string)
      arg(:orderasc, :string)
      arg(:orderdesc, :string)

      resolve(&Api.Schema.Query.all(&1, &2, Graph.Film))
    end
  end
end
