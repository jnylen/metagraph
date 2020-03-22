defmodule Api.Schema.Type.MediaGenre do
  use Absinthe.Schema.Notation

  object :media_genre do
    field(:uid, non_null(:string))

    field :label, :string do
      arg(:language, :string)
    end

    field :description, :string do
      arg(:language, :string)
    end
  end

  object :media_genre_queries do
    field(:media_genre, :media_genre)

    field(:media_genres, list_of(:media_genre))
  end
end
