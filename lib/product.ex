defmodule Store.Product do
  @moduledoc """
  Defines a shop Product

  Clients are able to buy units of these products.
  """

  @enforce_keys [:code, :name, :price]
  defstruct [:code, :name, :price]

  @typedoc """
  A store product

  Every product must define the following fields:

    * A unique `code` which is used as unique identifier.
    * A descriptive `name`.
    * A `price` in pound cents.
  """
  @type t :: %__MODULE__{
          code: String.t(),
          name: String.t(),
          price: Decimal.t()
        }

  @doc """
  Creates a new Product

  Creates a new Product given a `code`, `name` and `price`.

  ## Examples

      iex> Store.Product.new("foo", "Foo", Decimal.new(3))
      %Store.Product{code: "foo", name: "Foo", price: Decimal.new("3")}
  """
  @spec new(String.t(), String.t(), Decimal.t()) :: t()
  def new(code, name, price),
    do: %__MODULE__{code: code, name: name, price: price}
end
