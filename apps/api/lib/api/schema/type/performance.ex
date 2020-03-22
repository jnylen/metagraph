defmodule Api.Schema.Type.Performance do
  use Absinthe.Schema.Notation

  object :performance do
    field(:uid, non_null(:string))
    field(:note, :string)
    field(:film, :film)
    field(:person, :person)
  end
end
