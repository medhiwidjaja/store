defmodule Store.PricingRule.BuyXGetYFreeTest do
  use ExUnit.Case

  alias Store.Product
  alias Store.PricingRule.BuyXGetYFree, as: Rule
  alias Decimal, as: D

  describe "buy x get y free" do
    setup do
      product = %Product{code: "TEA", name: "Tea", price: D.new("2.0")}
      item = %{product: product, qty: 4}
      rule_opts = %{name: "Buy1Get1", code: "TEA", x: 1, y: 1}
      {:ok, %{item: item, rule_opts: rule_opts}}
    end

    test "applies buy one get one discount", %{item: item, rule_opts: rule_opts} do
      expected_total = D.new("4.0")

      %{discounted_total: total} = Rule.apply(item, rule_opts)

      assert D.eq?(total, expected_total)
    end

    test "adds discount info in line item", %{item: item, rule_opts: rule_opts} do
      item = Rule.apply(item, rule_opts)
      expected_total = D.new("4.0")

      assert [type: "Buy1Get1 discount", amount: expected_total] == item[:discount]
    end

    test "doesn't apply if qty doesn't meet minimum", %{item: item, rule_opts: rule_opts} do
      new_item = %{item | qty: 2}
      new_rule = %{rule_opts | x: 4}
      resulting_item = Rule.apply(new_item, new_rule)

      assert resulting_item[:discount] == nil
    end

    test "ignores items if product is different from rule", %{item: item, rule_opts: rule_opts} do
      product = %Product{code: "foo", name: "FOO", price: D.new("2.0")}
      resulting_item = Rule.apply(%{item | product: product}, rule_opts)

      assert resulting_item[:discount] == nil
    end
  end
end
