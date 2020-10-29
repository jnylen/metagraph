defmodule Api.Schema.Language do
  use Absinthe.Schema.Notation

  object :language do
    field(:value, :string)
    field(:language, :string)
  end

  input_object :language_input do
    field(:value, :string)
    field(:language, :string)
  end
end
