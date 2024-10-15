defmodule Store.Discounts do
  @moduledoc """
  Discounts manages loading of discounts from CSV files and lookup by code
  """

  alias Store.Discount

  @spec load() :: any()
  @doc """
  Load products from configuration data files
  """
  def load() do
    table = Application.fetch_env!(:store, :discount_ets)
    path = Application.fetch_env!(:store, :discounts)

    File.stream!(path, :line)
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> parse()
    end)
    |> Enum.each(fn {code, discount} ->
      :ets.insert(table, {code, discount})
    end)
  end

  defp parse(line) do
    [name, type, product, arg1, arg2, arg3, arg4] = String.split(line, ",")

    case type do
      "BuyXGetYFree" ->
        {product,
         Discount.new(name, get_module(type), %{
           name: name,
           code: product,
           x: String.to_integer(arg1),
           y: String.to_integer(arg2)
         })}

      "Bulk" ->
        case arg1 do
          "fixed" ->
            {product,
             Discount.new(name, get_module(type), %{
               name: name,
               type: "fixed",
               code: product,
               min_qty: String.to_integer(arg2),
               price: Decimal.new(arg3)
             })}

          "fraction" ->
            {product,
             Discount.new(name, get_module(type), %{
               name: name,
               type: "fraction",
               code: product,
               min_qty: String.to_integer(arg2),
               numerator: String.to_integer(arg3),
               denominator: String.to_integer(arg4)
             })}
        end
    end
  end

  defp get_module("BuyXGetYFree"), do: Store.PricingRule.BuyXGetYFree
  defp get_module("Bulk"), do: Store.PricingRule.Bulk

  @doc """
  Get product by the code

  ## Examples:
      iex> Store.Discounts.lookup("GR1")
      %Store.Discount{name: "CEO", type: Store.PricingRule.BuyXGetYFree, parameters: %{code: "GR1", name: "CEO", y: 1, x: 1}}
  """
  def lookup(code) do
    table = Application.fetch_env!(:store, :discount_ets)

    case :ets.lookup(table, code) do
      [] -> nil
      [{_, discount}] -> discount
    end
  end
end
