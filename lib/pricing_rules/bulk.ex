defmodule Store.PricingRule.Bulk do
  @behaviour Store.PricingRule

  alias Decimal, as: D

  @impl true
  def apply(
        %{product: %{code: product_code}} = item,
        %{code: code}
      )
      when product_code != code,
      do: item

  def apply(%{product: product, qty: qty}, %{min_qty: min_qty})
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
  def apply(%{product: product, qty: qty}, %{type: "fixed"} = opts) do
    %{name: name, price: price} = opts
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

  @impl true
  def apply(%{product: product, qty: qty}, %{type: "fraction"} = opts) do
    %{name: name, numerator: num, denominator: dem} = opts
    full_price = D.mult(product.price, D.new(qty))
    fraction = D.div(D.new(num), D.new(dem))
    discounted_price = product.price |> D.mult(fraction) |> D.mult(D.new(qty))

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
