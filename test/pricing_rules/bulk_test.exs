defmodule Store.PricingRule.BulkTest do
  use ExUnit.Case

  alias Store.Product
  alias Store.PricingRule.Bulk, as: Rule
  alias Decimal, as: D

  describe "Fixed price Bulk Pricing Rule" do
    setup do
      strawberry = %Product{code: "strawberry", name: "Strawberry", price: D.new("2.0")}
      item = %{product: strawberry, qty: 4}

      rule_opts = %{
        name: "Promo1",
        type: "fixed",
        code: "strawberry",
        min_qty: 3,
        price: D.new("1.5")
      }

      {:ok, %{item: item, rule_opts: rule_opts}}
    end

    test "applies discount price on bulk order", %{item: item, rule_opts: rule_opts} do
      # Expected total = 1.5 * 4 = 6.0
      expected_total = D.new("6.00")

      %{discounted_total: total} = Rule.apply(item, rule_opts)

      assert D.eq?(total, expected_total)
    end

    test "adds discount info in line item", %{item: item, rule_opts: rule_opts} do
      expected_discount = D.new("2.0")

      item = Rule.apply(item, rule_opts)

      assert [type: "Promo1 discount", amount: expected_discount] == item[:discount]
    end

    test "doesn't apply rule if qty doesn't meet minimum", %{item: item, rule_opts: rule_opts} do
      fewer_item = %{item | qty: 1}

      item = Rule.apply(fewer_item, rule_opts)

      assert item[:discount] == nil
    end

    test "ignores items if product is different from rule", %{item: item, rule_opts: rule_opts} do
      product = %Product{code: "foo", name: "FOO", price: D.new("2.0")}
      resulting_item = Rule.apply(%{item | product: product}, rule_opts)

      assert resulting_item[:discount] == nil
    end
  end

  describe "Fraction discount price Bulk Pricing Rule" do
    setup do
      coffee = %Product{code: "coffee", name: "Coffee", price: D.new("6.0")}
      item = %{product: coffee, qty: 4}

      rule_opts = %{
        name: "Promo2",
        type: "fraction",
        code: "coffee",
        min_qty: 3,
        numerator: 2,
        denominator: 3
      }

      {:ok, %{item: item, rule_opts: rule_opts}}
    end

    test "applies discount price on bulk order", %{item: item, rule_opts: rule_opts} do
      # Expected total = 6.0 * (2/3) * 4 = 16.0
      expected_total = D.new("16.00")

      %{discounted_total: total} = Rule.apply(item, rule_opts)

      assert D.eq?(total, expected_total)
    end

    test "adds discount info in line item", %{item: item, rule_opts: rule_opts} do
      # Original total 24.0 minus Discounted total 16.0
      expected_discount = D.new("8.0")

      item = Rule.apply(item, rule_opts)

      assert D.eq?(expected_discount, item[:discount][:amount])
    end

    test "doesn't apply rule if qty doesn't meet minimum", %{item: item, rule_opts: rule_opts} do
      fewer_item = %{item | qty: 1}

      item = Rule.apply(fewer_item, rule_opts)

      assert item[:discount] == nil
    end

    test "ignores items if product is different from rule", %{item: item, rule_opts: rule_opts} do
      product = %Product{code: "foo", name: "FOO", price: D.new("2.0")}
      resulting_item = Rule.apply(%{item | product: product}, rule_opts)

      assert resulting_item[:discount] == nil
    end
  end
end
