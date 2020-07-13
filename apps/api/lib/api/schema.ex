defmodule Api.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom
  import_types Api.Schema.Language
  import_types Api.Schema.Genre
  import_types Api.Schema.Film
  import_types Api.Schema.Person

  query do
    import_fields :film_queries
    import_fields :person_queries
  end
end
