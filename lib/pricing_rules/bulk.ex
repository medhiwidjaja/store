defmodule Store.PricingRule.Bulk do
  @behaviour Store.PricingRule

  alias Decimal, as: D

  @impl true
  def apply(product, qty, name: _, type: "fixed", min_qty: min_qty, price: _)
      when qty < min_qty do
    full_price = D.mult(product.price, D.new(qty))

    # Quantity doesn't meet threshold, so no discount added
    %{
      product: product,
      qty: qty,
      line_total: full_price
    }
  end

  @impl true
  def apply(product, qty, name: name, type: "fixed", min_qty: _, price: price) do
    full_price = D.mult(product.price, D.new(qty))
    discounted_price = D.mult(price, D.new(qty))

    %{
      product: product,
      qty: qty,
      line_total: full_price,
      discounted_total: discounted_price,
      discount: [
        type: "#{name} discount",
        amount: D.sub(full_price, discounted_price)
      ]
    }
  end
end
