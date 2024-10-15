defmodule Store.PricingRule.BuyXGetYFreeTest do
  use ExUnit.Case

  alias Store.Product
  alias Store.PricingRule.BuyXGetYFree, as: Rule
  alias Decimal, as: D

  describe "buy x get y free" do
    setup do
      product = %Product{code: "TEA", name: "Tea", price: D.new("2.0")}
      {:ok, %{product: product}}
    end

    test "applies buy one get one discount on bulk order", %{product: product} do
      qty = 4
      expected_total = D.new("4.0")
      %{discounted_total: total} = Rule.apply(product, qty, min_qty: 1, free_qty: 1)

      assert D.eq?(total, expected_total)
    end

    test "adds discount info in line item", %{product: product} do
      qty = 4
      item = Rule.apply(product, qty, min_qty: 1, free_qty: 1)
      expected_total = D.new("4.0")

      assert [type: " discount", amount: expected_total] == item[:discount]
    end

    test "doesn't apply if qty doesn't meet minimum", %{product: product} do
      qty = 2
      item = Rule.apply(product, qty, min_qty: 3, free_qty: 1)

      assert item[:discount] == nil
    end
  end
end
