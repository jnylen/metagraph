defmodule Api.Schema.Type.TV do
  use Absinthe.Schema.Notation

  object :tv do
    field(:uid, non_null(:string))

    field :label, :string do
      arg(:language, :string)
    end

    field :description, :string do
      arg(:language, :string)
    end

    field(:website, :string)
    field(:wikidata_id, :string)
    field(:imdb_id, :string)
    field(:freebase_id, :string)
    field(:themoviedb_id, :integer)
    field(:thetvdb_id, :integer)

    field(:genre, list_of(:media_genre))
  end

  object :tv_queries do
    field :tv, :tv do
      arg(:uid, non_null(:string))

      resolve(&Api.Schema.Query.get(&1, &2, Graph.Tv))
    end

    field :tvs, list_of(:tv) do
      arg(:offset, :integer)
      arg(:first, :string)
      arg(:orderasc, :string)
      arg(:orderdesc, :string)

      resolve(&Api.Schema.Query.all(&1, &2, Graph.Tv))
    end
  end
end
