defmodule Api.Schema.Genre do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.Genre, as: GenreResolver

  object :genre do
    field :uid, :string
    field :label, list_of(:language)
    field :description, list_of(:language)
  end

  object :genre_queries do
    field :genres, list_of(:genre) do
      resolve &GenreResolver.list/3
    end

    field :genre, :genre do
      arg :uid, non_null(:string)
      resolve &GenreResolver.find/3
    end
  end
end
