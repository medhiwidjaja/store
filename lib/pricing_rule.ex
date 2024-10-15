defmodule Store.PricingRule do
  @moduledoc """
  Behaviour for defining discounts.

  Contains callbacks for applying discount
  """

  @doc """
  Apply discount on products
  """
  @callback apply(product :: Store.Product.t(), qty :: integer(), opts :: Keyword.t()) ::
              Store.Cart.item()
end
