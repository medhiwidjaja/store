defmodule Store.Products do
  @moduledoc """
  Product Context
  """

  alias Store.Product

  @spec load() :: any()
  @doc """
  Load products from configuration data files
  """
  def load() do
    table = Application.fetch_env!(:store, :product_ets)
    path = Application.fetch_env!(:store, :products)

    File.stream!(path, :line)
    |> Enum.reduce(%{}, fn line, acc ->
      line
      |> String.trim()
      |> parse(acc)
    end)
    |> Enum.each(fn {code, product} ->
      :ets.insert(table, {code, product})
    end)
  end

  defp parse(line, acc) do
    [code, name, price] = String.split(line, ",")

    acc
    |> Map.put(code, Product.new(code, name, Decimal.new(price)))
  end

  @doc """
  Get product by the code

  ## Examples:
      iex> Store.Products.lookup("GR1")
      %Store.Product{code: "GR1", name: "Green tea", price: Decimal.new("3.11")}
  """
  def lookup(code) do
    table = Application.fetch_env!(:store, :product_ets)

    case :ets.lookup(table, code) do
      [] -> nil
      [{_, product}] -> product
    end
  end
end
