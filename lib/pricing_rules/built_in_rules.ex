defmodule Store.PricingRules.BuiltInRules do
  @doc """
  These are the built-in rules.
  All rules take parameters: a tuple {%{}, qty}, and optional parameters
  A rule has to return: a tuple of updated Product map, quantity and a total
      {%{}, qty, total}
  """

  # Built-in Discount rules

  def bulk_discount({%{price: price} = p, qty},
        min_qty: min_qty,
        discounted_price: discounted_price
      ) do
    if qty >= min_qty do
      {%{p | price: discounted_price}, qty, discounted_price * qty}
    else
      {p, qty, qty * price}
    end
  end

  def fraction_discount({%{price: price} = p, qty},
        min_qty: min_qty,
        multiplier: multiplier
      ) do
    if qty >= min_qty do
      {%{p | price: price * multiplier}, qty, price * multiplier * qty}
    else
      {p, qty, qty * price}
    end
  end

  def buy_one_get_one({%{price: price} = p, qty}) do
    {p, qty, (div(qty, 2) + rem(qty, 2)) * price}
  end
end
