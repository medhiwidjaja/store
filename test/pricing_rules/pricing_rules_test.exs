defmodule Store.PricingRulesTest do
  use ExUnit.Case

  alias Store.PricingRules

  describe "pricing_rules" do
    setup do
      {:ok, _} = PricingRules.start_link(%{inc: &(&1 + 1)})
      :ok
    end

    test "get_rule/1 returns the rule with given name" do
      assert PricingRules.get_rule(:inc).(1) == 2
    end

    test "add_rule/1 with valid parameters stores the rule" do
      assert :ok = PricingRules.add_rule(:decr, &(&1 - 1))
      assert PricingRules.get_rule(:decr).(2) == 1
    end

    test "add_rule/1 with invalid data returns an error" do
      assert :error = PricingRules.add_rule("INC", &(&1 + 1))
      assert :error = PricingRules.add_rule(:decr, :decrement)
    end
  end
end
