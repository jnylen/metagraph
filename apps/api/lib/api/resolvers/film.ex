defmodule Api.Resolvers.Film do

  def list(_parent, _args, _resolution) do
    {:ok, []}
  end

  def find(_parent, %{uid: uid}, _resolution) do
    uid
    |> Graph.Repo.get()
    |> case do
      {:ok, nil} ->
        {:error, "Item not found"}

      {:ok, {:error, _}} -> {:error, "Error occur"}

      val -> val
    end
  end

  @doc """
  Create an item
  """
  #def create(_parent, _args, %{context: %{current_user: nil}}), do: {:error, "Access denied"}
  def create(_parent, args, %{context: %{current_user: user}})  do
    %Graph.Film{}
    |> Graph.Film.changeset(args)
    |> IO.inspect()
    |> Graph.Repo.set()
    |> IO.inspect()
  end

  def create(_parent, _args, _resolution), do: {:error, "Access denied"}
end
