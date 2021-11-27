defmodule Store.PricingRules.BuiltInRulesTest do
  use ExUnit.Case

  alias Store.Products.Product
  alias Store.PricingRules.BuiltInRules, as: Rules

  describe "bulk discount" do
    test "applies discount on bulk order" do
      product = %Product{code: "TEA", name: "Tea", price: 2.0}
      qty = 4
      {_, _qty, total} = Rules.bulk_discount({product, qty}, min_qty: 3, discounted_price: 1.5)
      assert total == 6.0
    end

    test "doesn't apply discount if order is less than the threshold" do
      product = %Product{code: "TEA", name: "Tea", price: 2.0}
      qty = 2
      {_, _qty, total} = Rules.bulk_discount({product, qty}, min_qty: 3, discounted_price: 1.5)
      assert total == 4.0
    end
  end
end
