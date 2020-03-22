defmodule Api.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)

  import_types(Api.Schema.Type.Film)
  import_types(Api.Schema.Type.MediaGenre)
  import_types(Api.Schema.Type.Performance)
  import_types(Api.Schema.Type.Person)

  query do
    import_fields(:film_queries)
    import_fields(:person_queries)
    import_fields(:media_genre_queries)
  end
end
