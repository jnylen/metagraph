defmodule FrontendWeb.BrowseLive.DataItem do
  use FrontendWeb, :live_component

  import FrontendWeb.ItemHelpers

  def count_keys(item) do
    Map.from_struct(item)
    |> Enum.into([])
    |> Enum.reject(fn {_key, value} -> empty_value?(value) end)
    |> Enum.count()
  end

  def count_facts(item) do
    {_, amount} =
      Map.from_struct(item)
      |> Enum.into([])
      |> Enum.reject(fn {_key, value} -> empty_value?(value) end)
      |> Enum.map_reduce(0, fn {_key, value}, acc ->
        {value, acc + value_amount(value)}
      end)

    amount
  end

  defp empty_value?([]), do: true
  defp empty_value?(nil), do: true
  defp empty_value?(""), do: true
  defp empty_value?(_), do: false

  defp value_amount(list) when is_list(list), do: Enum.count(list)
  defp value_amount(_), do: 1
end
