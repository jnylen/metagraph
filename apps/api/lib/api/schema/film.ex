defmodule Api.Schema.Film do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.Film, as: FilmResolver

  object :film do
    field(:uid, :string)
    field(:label, list_of(:language))
    field(:description, list_of(:language))
    field(:website, :string)
    field(:budget, :integer)
    field(:revenue, :integer)
    field(:wikidata_id, :string)
    field(:imdb_id, :string)
    field(:freebase_id, :string)
    field(:themoviedb_id, :integer)
    field(:omdb_id, :integer)
    field(:elonet_id, :integer)
    field(:adult, :boolean)
    field(:genre, list_of(:genre))
  end

  object :film_queries do
    field :films, list_of(:film) do
      arg(:query_field, :string, default_value: "label")
      arg(:query, :string)
      arg(:count, :integer, default_value: 10)
      arg(:offset, :integer, default_value: 0)

      resolve(&FilmResolver.list/3)
    end

    field :film, :film do
      arg(:uid, non_null(:string))
      resolve(&FilmResolver.find/3)
    end
  end

  object :film_mutations do
    field :create_film, type: :film do
      arg(:label, list_of(:language_input))
      arg(:description, list_of(:language_input))
      arg(:website, :string)
      arg(:budget, :integer)
      arg(:revenue, :integer)
      arg(:wikidata_id, :string)
      arg(:imdb_id, :string)
      arg(:freebase_id, :string)
      arg(:themoviedb_id, :integer)
      arg(:omdb_id, :integer)
      arg(:elonet_id, :integer)
      arg(:adult, :boolean)
      arg(:genre, list_of(:genre_input))

      resolve(&FilmResolver.create/3)
    end
  end
end
