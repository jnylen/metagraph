defmodule Api.Schema.Genre do
  use Absinthe.Schema.Notation

  alias Api.Resolvers.Genre, as: GenreResolver

  object :genre do
    field :uid, :string
    field :label, list_of(:language)
    field :description, list_of(:language)
  end

  input_object :genre_input do
    field :uid, :string
  end

  object :genre_queries do
    field :genres, list_of(:genre) do
      arg :count, :integer, default_value: 10
      arg :offset, :integer, default_value: 0

      resolve &GenreResolver.list/3
    end

    field :genre, :genre do
      arg :uid, non_null(:string)
      resolve &GenreResolver.find/3
    end
  end
end
