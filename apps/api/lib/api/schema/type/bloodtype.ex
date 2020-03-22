defmodule Api.Schema.Type.Bloodtype do
  use Absinthe.Schema.Notation

  object :bloodtype do
    field(:uid, non_null(:string))

    field :label, :string do
      arg(:language, :string)
    end

    field :description, :string do
      arg(:language, :string)
    end
  end

  object :bloodtype_queries do
    field :bloodtype, :bloodtype do
      arg(:uid, non_null(:string))

      resolve(&Api.Schema.Query.get(&1, &2, Graph.Bloodtype))
    end

    field :bloodtypes, list_of(:bloodtype) do
      arg(:offset, :integer)
      arg(:first, :string)
      arg(:orderasc, :string)
      arg(:orderdesc, :string)

      resolve(&Api.Schema.Query.all(&1, &2, Graph.Bloodtype))
    end
  end
end
