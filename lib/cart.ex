defmodule Store.Cart do
  @moduledoc """
  Defines Store Cart

  A Cart represents a list of the products that clients bring to the checkout line
  """
  alias Store.Product
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
end
