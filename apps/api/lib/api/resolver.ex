defmodule Api.Resolver do
  @callback struct_name() :: state when state: any

  defmacro __using__(_opts) do
    quote do
      @behavior Api.Resolver

      def list(parent, args, resolution),
        do: Api.Resolver.list(__MODULE__, parent, args, resolution)

      defoverridable list: 3

      defdelegate find(_parent, _args, _resolution), to: Api.Resolver
      defoverridable find: 3

      def create(parent, args, resolution),
        do: Api.Resolver.create(__MODULE__, parent, args, resolution)

      defoverridable create: 3
    end
  end

  def list(module, _parent, %{count: count, offset: offset} = args, _resolution) do
    %{lookup: lookup} = Graph.Repo.meta()

    statement(module, args)
    |> case do
      {:error, msg} -> {:error, msg}
      val -> Dlex.query(Graph.Repo, val)
    end
    |> case do
      {:ok, %{"uid_get" => nodes}} ->
        val =
          nodes
          |> Enum.map(fn node ->
            {:ok, data} = Dlex.Repo.decode(node, lookup)

            data
          end)

        {:ok, val}

      {:error, msg} ->
        {:error, msg}
    end
  end

  def find(_parent, %{uid: uid}, _resolution) do
    uid
    |> Graph.Repo.get()
    |> case do
      {:ok, nil} ->
        {:error, "Item not found"}

      {:ok, {:error, _}} ->
        {:error, "Error occur"}

      val ->
        val
    end
  end

  @doc """
  Create an item
  """
  def create(_module, _parent, _args, %{context: %{current_user: nil}}),
    do: {:error, "Access denied"}

  def create(module, _parent, args, %{context: %{current_user: user}}) do
    model = module.struct_name

    model
    |> struct()
    |> model.changeset(args)
    |> Editor.create(user)
  end

  def create(_module, _parent, _args, _resolution), do: {:error, "Access denied"}

  defp statement(module, %{query_field: field, query: query, count: count, offset: offset}) do
    source_name = module.struct_name.__schema__(:source)
    field_name = field_name(module, field)

    query_text(module, field_name, query)
    |> case do
      :error ->
        {:error, "Unable to filter on that query"}

      query_text ->
        [
          "{uid_get(func: ",
          query_text |> Enum.join(""),
          ", first: ",
          to_string(count),
          ", offset: ",
          to_string(offset),
          ") @filter(type(",
          source_name,
          ")) {uid dgraph.type expand(_all_) { uid dgraph.type expand(_all_)}}}"
        ]
        |> List.flatten()
    end
  end

  defp statement(module, %{count: count, offset: offset}) do
    source_name = module.struct_name.__schema__(:source)

    [
      "{uid_get(func: type(",
      source_name,
      "), first: ",
      to_string(count),
      ", offset: ",
      to_string(offset),
      ") {uid dgraph.type expand(_all_) { uid dgraph.type expand(_all_)}}}"
    ]
  end

  defp field_name(module, field_name) do
    module.struct_name.__schema__(:field, String.to_existing_atom(field_name))
  rescue
    _ -> :error
  end

  defp query_text(_module, :error, _), do: :error

  defp query_text(module, field_name, query) do
    module.struct_name.__schema__(:field, field_name)
    |> case do
      {_, :lang} -> ["anyofterms(", "#{field_name}@.", ", \"", query, "\"", ")"]
      {_, :integer} -> ["eq(", field_name, ", ", query |> String.to_integer(), ")"]
      {_, :string} -> ["anyofterms(", field_name, ", \"", query, "\"", ")"]
      _ -> :error
    end
  rescue
    _ -> :error
  end
end
