defmodule Store.PricingRule.BulkTest do
  use ExUnit.Case

  alias Store.Product
  alias Store.PricingRule.Bulk, as: Rule
  alias Decimal, as: D

  describe "Fixed price Bulk Pricing Rule" do
    setup do
      strawberry = %Product{code: "strawberry", name: "Strawberry", price: D.new("2.0")}
      {:ok, %{product: strawberry}}
    end

    test "applies discount price on bulk order", %{product: product} do
      qty = 4
      discounted_price = D.new("1.5")
      # Expected total = 1.5 * 4 = 6.0
      expected_total = D.new("6")

      %{discounted_total: total} =
        Rule.apply(product, qty,
          name: "Promo1",
          type: "fixed",
          min_qty: 3,
          price: discounted_price
        )

      assert D.eq?(total, expected_total)
    end

    test "adds discount info in line item", %{product: product} do
      qty = 4
      discounted_price = D.new("1.5")
      expected_discount = D.new("2.0")

      item =
        Rule.apply(product, qty,
          name: "Promo1",
          type: "fixed",
          min_qty: 3,
          price: discounted_price
        )

      assert [type: "Promo1 discount", amount: expected_discount] == item[:discount]
    end

    test "doesn't apply rule if qty doesn't meet minimum", %{product: product} do
      qty = 2
      discounted_price = D.new("1.5")

      item =
        Rule.apply(product, qty,
          name: "Promo1",
          type: "fixed",
          min_qty: 3,
          price: discounted_price
        )

      assert item[:discount] == nil
    end
  end

  describe "Fraction discount price Bulk Pricing Rule" do
    setup do
      coffee = %Product{code: "coffee", name: "Coffee", price: D.new("6.0")}
      {:ok, %{product: coffee}}
    end

    test "applies discount price on bulk order", %{product: product} do
      qty = 4
      numerator = 2
      denominator = 3
      # Expected total = 6.0 * (2/3) * 4 = 16.0
      expected_total = D.new("16")

      %{discounted_total: total} =
        Rule.apply(product, qty,
          name: "Promo2",
          type: "fraction",
          min_qty: 3,
          numerator: numerator,
          denominator: denominator
        )

      assert D.eq?(total, expected_total)
    end

    test "adds discount info in line item", %{product: product} do
      qty = 4
      numerator = 2
      denominator = 3
      # Original total 24.0 minus Discounted total 16.0
      expected_discount = D.new("8.0")

      item =
        Rule.apply(product, qty,
          name: "Promo2",
          type: "fraction",
          min_qty: 3,
          numerator: numerator,
          denominator: denominator
        )

      assert D.eq?(expected_discount, item[:discount][:amount])
    end

    test "doesn't apply rule if qty doesn't meet minimum", %{product: product} do
      qty = 1
      numerator = 2
      denominator = 3

      item =
        Rule.apply(product, qty,
          name: "Promo2",
          type: "fraction",
          min_qty: 3,
          numerator: numerator,
          denominator: denominator
        )

      assert item[:discount] == nil
    end
  end
end
