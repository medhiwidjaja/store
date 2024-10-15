defmodule Store.PricingRule.BuyXGetYFree do
  @behaviour Store.PricingRule

  alias Decimal, as: D

  @impl true
  def apply(
        %{product: %{code: product_code}} = item,
        %{code: code}
      )
      when product_code != code,
      do: item

  def apply(%{product: product, qty: qty}, %{x: x})
      when qty < x do
    full_price = D.mult(product.price, D.new(qty))
    # Quantity doesn't meet threshold, so no discount added
    %{
      product: product,
      qty: qty,
      line_total: full_price
    }
  end

  @impl true
  def apply(%{product: product, qty: qty}, opts) do
    %{name: name, x: x, y: y} = opts

    # Quantity meets threshold, so discount will be added to the line item
    full_price = D.mult(product.price, D.new(qty))
    disc_qty = calculate_quantity(qty, x, y) |> D.new()
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

  defp calculate_quantity(qty, x, free) do
    full_sets = x * div(qty, x + free)
    remaining = min(x, rem(qty, x + free))

    full_sets + remaining
  end
end
