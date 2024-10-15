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

  @doc """
  Applies a Store.PricingRule to a line item in a cart

  discount_type -- a module that implements PricingRule behaviour
  item -- one line item in a Store.Cart
  parameters -- options to be passed to the PricingRule
  """
  @spec apply(atom(), Store.Cart.item(), map()) :: Store.Cart.item()
  def apply(discount_type, item, parameters),
    do: Kernel.apply(discount_type, :apply, [item, parameters])
end
