defmodule Store.Discount do
  @moduledoc """
  Store.Discount represents a store promotion rule that can be applied
  to a Store.Cart. When applied, Discount may modify each line items
  in the Cart for each applicable rule for the product in the line item.

  Each Discount has a Store.PricingRule which defines the rules.
  """

  alias Store.{Cart, PricingRule}

  @enforce_keys [:type, :parameters]
  defstruct [:type, :parameters]

  @typedoc """
  A Discount promotion

  type - a module that implements Store.PricingRule
  parameters - the parameters of the PricingRule
  """
  @type t :: %__MODULE__{
          type: atom(),
          parameters: map()
        }

  @doc """
  Creates a new Store.Discount given the type and the parameters

  ## Examples

      iex> Store.Discount.new(Store.PricingRule.Bulk, %{})
      %Store.Discount{type: Store.PricingRule.Bulk, parameters: %{}}
  """
  @spec new(atom(), map()) :: t()
  def new(type, parameters),
    do: %__MODULE__{type: type, parameters: parameters}

  @doc """
  Applies a Store.Discount to a Store.Cart

  ## Examples

      iex> tea = Store.Product.new("GR1", "Green Tea", Decimal.new("3.11"))
      iex> cart = Store.Cart.new()
      ...>   |> Store.Cart.add(tea)
      ...>   |> Store.Cart.add(tea)
      iex> discount = Store.Discount.new(Store.PricingRule.BuyXGetYFree, %{name: "B1G1", code: "GR1", x: 1, y: 1})
      iex> Store.Discount.apply(cart, discount)
      %Store.Cart{
        items: [
          {"GR1",
          %{
            product: %Store.Product{
              code: "GR1",
              name: "Green Tea",
              price: Decimal.new("3.11")
            },
            qty: 2,
            line_total: Decimal.new("6.22"),
            discount: [type: "B1G1 discount", amount: Decimal.new("3.11")],
            discounted_total: Decimal.new("3.11")
          }}
        ]
      }
  """
  def apply(cart, %{type: type, parameters: params}) do
    items =
      cart.items
      |> Enum.map(fn {code, item} -> {code, PricingRule.apply(type, item, params)} end)

    %Cart{cart | items: items}
  end
end
