defmodule Store.PricingRule do
  @moduledoc """
  Behaviour for defining discounts.

  Contains callbacks for applying discount
  """

  @doc """
  Apply discount on a cart item
  """
  @callback apply(item :: Store.Cart.item(), params :: map()) ::
              Store.Cart.item()
end
