defmodule Api.Resolvers.Item do
  @doc """
  List all items of a specific type
  """
  def list(_parent, _args, _resolution) do
    {:ok, []}
  end

  @doc """
  Find an specific item
  """
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
  def create(_parent, args, %{context: %{current_user: user}}) when not is_nil(user) do

  end

  def create(_parent, _args, _resolution) do
    {:error, "Access denied"}
  end
end
