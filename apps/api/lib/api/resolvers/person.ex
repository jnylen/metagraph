defmodule Api.Resolvers.Person do

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

end
