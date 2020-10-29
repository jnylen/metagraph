defimpl Scrivener.Paginater, for: Graph.PaginateQuery do
  alias Scrivener.{Config, Page}

  @moduledoc false

  alias Graph.Repo

  @spec paginate(Elastic.Query.t(), Scrivener.Config.t()) :: Scrivener.Page.t()
  def paginate(query, %Config{page_size: page_size, page_number: page_number, module: mod}) do
    {:ok, %{"results" => [%{"count" => total_entries}]}} = total_entries(query)

    %Page{
      page_size: page_size,
      page_number: page_number,
      entries: entries(query, mod, page_number, page_size),
      total_entries: total_entries,
      total_pages: total_pages(total_entries, page_size)
    }
  end

  def total_entries(%Graph.PaginateQuery{model: model}) do
    query = """
    {
      results(func: type("#{model.__schema__(:source)}")) {
        count(uid)
      }
    }
    """

    Repo.all(query)
  end

  def entries(%Graph.PaginateQuery{model: model}, mod, page_number, page_size) do
    offset = page_size * (page_number - 1)

    query = """
    {
      results(func: type("#{model.__schema__(:source)}"), first: #{page_size}, offset: #{offset}) {
        uid
        dgraph.type
        expand(_all_) {
          uid
          dgraph.type
          expand(_all_)
        }
      }
    }
    """

    {:ok, %{"results" => results}} = Repo.all(query)

    results
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t

      pos when pos > 0 ->
        t + 1

      _ ->
        t
    end
  end

  defp total_pages(total_entries, page_size) do
    ceiling(total_entries / page_size)
  end
end
