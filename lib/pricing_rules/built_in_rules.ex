defmodule Store.PricingRules.BuiltInRules do
  @doc """
  These are the built-in rules.
  All rules take parameters: a tuple {%Product{}, qty}, and optional parameters
  A rule has to return: a tuple of updated Product map, quantity and a total
      {%{Product{}, qty, total}
  """
  alias Store.Products.Product
  # Built-in Discount rules

  def bulk_discount({%Product{} = p, qty}, min_qty: min_qty, discounted_price: discounted_price) do
    if qty >= min_qty do
      {%{p | price: discounted_price}, qty, discounted_price * qty}
    else
      {p, qty, qty * p.price}
    end
  end
end
