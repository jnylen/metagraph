defmodule Graph.Repo do
  use Dlex.Repo,
    otp_app: :graph,
    modules: [
      Graph.Film,
      Graph.Tv,
      Graph.Media.Genre,
      Graph.Person,
      Graph.Bloodtype,
      Graph.Mediator.Performance
    ]

  # To do, actually paginate...
  def paginate(model, _queryies) do
    langs =
      Map.get(meta(), :modules, [])
      |> Enum.map(&Dlex.Repo.grab_all_langs/1)
      |> Enum.concat()
      |> Enum.uniq()
      |> Enum.join(" ")
      |> String.trim()

    query = """
    {
      queries(func: type("#{model.__schema__(:source)}")) {
        uid
        dgraph.type
        #{langs}
        expand(_all_) {
          uid
          dgraph.type
          #{langs}
          expand(_all_)
        }
      }
    }
    """

    all(query)
  end
end
