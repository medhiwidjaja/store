defmodule Store.PricingRule.BuyXGetYFree do
  @behaviour Store.PricingRule

  alias Decimal, as: D

  @impl true
  def apply(product, qty, min_qty: min_qty, free_qty: _) when qty < min_qty do
    full_price = D.mult(product.price, D.new(qty))
    # Quantity doesn't meet threshold, so no discount added
    %{
      product: product,
      qty: qty,
      line_total: full_price
    }
  end

  @impl true
  def apply(product, qty, opts) do
    name = Keyword.get(opts, :name)
    min_qty = Keyword.get(opts, :min_qty)
    free_qty = Keyword.get(opts, :free_qty)

    # Quantity meets threshold, so discount will be added to the line item
    full_price = D.mult(product.price, D.new(qty))
    disc_qty = calculate_quantity(qty, min_qty, free_qty) |> D.new()
    discounted_price = product.price |> D.mult(disc_qty)

    %{
      product: product,
      qty: qty,
      line_total: full_price,
      discounted_total: discounted_price,
      discount: [
        type: "#{name} discount",
        amount: full_price |> D.sub(discounted_price)
      ]
    }
  end

  defp calculate_quantity(qty, min_qty, free) do
    full_sets = min_qty * div(qty, min_qty + free)
    remaining = min(min_qty, rem(qty, min_qty + free))

    full_sets + remaining
  end
end
