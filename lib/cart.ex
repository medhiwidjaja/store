defmodule Store.Cart do
  @moduledoc """
  Defines Store Cart

  A Cart represents a list of the products that clients bring to the checkout line
  """
  alias Store.{Product}
  alias Decimal, as: D

  @type item() :: %{
          product: Product.t(),
          qty: integer(),
          line_total: D.t(),
          discounted_total: D.t(),
          discount: [name: String.t(), amount: D.t()]
        }

  @type t() :: %__MODULE__{
          created_at: DateTime.t() | nil,
          items: %{(code :: String.t()) => item :: item()}
        }

  @enforce_keys [:items]
  defstruct [:created_at, :items]

  @doc """
  Creates a new `Store.Cart`

  ## Examples

      iex> Store.Cart.new()
      %Store.Cart{items: %{}}
  """
  @spec new() :: t()
  def new(), do: %__MODULE__{items: %{}}

  @doc """
  Adds a product to the cart given the product code.

  It gets the product using the lookup function from the Product context.
  Ignores when product code doesn't exist.

  It also updates the cart line items quantity, and calculates the line_total
  """
  @spec add(t(), String.t()) :: t()
  def add(cart, nil), do: cart

  def add(cart, product) do
    default = %{product: product, qty: 1, line_total: product.price}

    updated_items =
      cart.items
      |> Map.update(product.code, default, fn item ->
        updated_qty = (item[:qty] + 1) |> D.new()

        item
        |> Map.update!(:qty, &(&1 + 1))
        |> Map.update!(:line_total, fn _ -> D.mult(product.price, updated_qty) end)
      end)

    %__MODULE__{cart | items: updated_items}
  end
end
