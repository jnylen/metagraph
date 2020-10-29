defmodule Graph.PaginateQuery do
  defstruct model: nil

  use Scrivener, page_size: 20, max_page_size: 30

  def for_model(model), do: %Graph.PaginateQuery{model: model}
end
