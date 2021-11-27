defmodule Store.PricingRules.BuiltInRulesTest do
  use ExUnit.Case

  alias Store.Products.Product
  alias Store.PricingRules.BuiltInRules, as: Rules

  describe "bulk discount" do
    test "applies bulk discount on bulk order" do
      product = %Product{code: "TEA", name: "Tea", price: 2.0}
      qty = 4
      {_, _qty, total} = Rules.bulk_discount({product, qty}, min_qty: 3, discounted_price: 1.5)
      assert total == 6.0
    end

    test "doesn't apply bulk discount if order is less than the threshold" do
      product = %Product{code: "TEA", name: "Tea", price: 2.0}
      qty = 2
      {_, _qty, total} = Rules.bulk_discount({product, qty}, min_qty: 3, discounted_price: 1.5)
      assert total == 4.0
    end
  end

  describe "fraction discount" do
    test "applies fraction discount on bulk order" do
      product = %Product{code: "TEA", name: "Tea", price: 2.0}
      qty = 4
      {_, _qty, total} = Rules.fraction_discount({product, qty}, min_qty: 3, multiplier: 0.5)
      assert total == 4.0
    end

    test "doesn't apply fraction discount if order is less than the threshold" do
      product = %Product{code: "TEA", name: "Tea", price: 2.0}
      qty = 2
      {_, _qty, total} = Rules.fraction_discount({product, qty}, min_qty: 3, multiplier: 0.5)
      assert total == 4.0
    end
  end

  describe "buy one get one discount" do
    test "applies buy one get one discount on bulk order" do
      product = %Product{code: "TEA", name: "Tea", price: 2.0}
      qty = 4
      {_, _qty, total} = Rules.buy_one_get_one({product, qty})
      assert total == 4.0
    end
  end
end
