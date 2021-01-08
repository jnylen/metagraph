defmodule Graph.Repo do
  use Dlex.Repo,
    otp_app: :graph,
    modules: [
      Graph.Film,
      Graph.Tv,
      Graph.Media.Genre,
      Graph.Person,
      Graph.Bloodtype,
      Graph.Mediator.Crew,
      Graph.Mediator.Performance
    ]

  def get_new(uid) do
    meta = meta()
    %{lookup: lookup} = meta

    langs =
      Map.get(meta, :modules, [])
      |> Enum.map(&Dlex.Repo.grab_all_langs/1)
      |> Enum.concat()
      |> Enum.uniq()
      |> Enum.join(" ")
      |> String.trim()

    statement =
      [
        "{uid_get(func: uid(",
        uid,
        ")) {uid dgraph.type #{langs} expand(_all_) { uid dgraph.type #{langs} expand(_all_) { uid dgraph.type expand(_all_) }}}}"
      ]
      |> IO.inspect()

    with {:ok, %{"uid_get" => nodes}} <- Dlex.query(Graph.Repo, statement) do
      case nodes do
        [%{"uid" => _, "dgraph.type" => types} = map] when map_size(map) < 2 and types != [] ->
          {:ok, nil}

        [map] ->
          Dlex.Repo.decode(map, lookup)
      end
    end
  end
end
