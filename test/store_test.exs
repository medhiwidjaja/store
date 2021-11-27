defmodule StoreTest do
  use ExUnit.Case
  doctest Store

  alias Store.Checkout
  alias Store.Products
  alias Store.{Promotions, Promotions.Promotion}
  alias Store.{PricingRules, PricingRules.BuiltInRules}

  @gr1 %{code: "GR1", name: "Green tea", price: 3.11}
  @sr1 %{code: "SR1", name: "Strawberries", price: 5.0}
  @cf1 %{code: "CF1", name: "Coffee", price: 11.23}

  setup do
    Products.start_link(%{@gr1.code => @gr1, @sr1.code => @sr1, @cf1.code => @cf1})

    PricingRules.start_link(%{
      bulk: &BuiltInRules.bulk_discount/2,
      fraction: &BuiltInRules.fraction_discount/2,
      buy1get1: &BuiltInRules.buy_one_get_one/1
    })

    Promotions.start_link(%{
      "GR1" => %Promotion{code: "GR1", rule: :buy1get1},
      "SR1" => %Promotion{code: "SR1", rule: :bulk, opts: [min_qty: 3, discounted_price: 4.50]},
      "CF1" => %Promotion{code: "CF1", rule: :fraction, opts: [min_qty: 3, multiplier: 2.0 / 3.0]}
    })

    {:ok, cart} = Checkout.start_link()
    {:ok, cart: cart}
  end

  test "case 1", %{cart: cart} do
    Checkout.scan(cart, ["GR1", "SR1", "GR1", "GR1", "CF1"])
    assert Checkout.total(cart) == 22.45
  end

  test "case 2", %{cart: cart} do
    Checkout.scan(cart, ["GR1", "GR1"])
    assert Checkout.total(cart) == 3.11
  end

  test "case 3", %{cart: cart} do
    Checkout.scan(cart, ["SR1", "SR1", "GR1", "SR1"])
    assert Checkout.total(cart) == 16.61
  end

  test "case 4", %{cart: cart} do
    Checkout.scan(cart, ["GR1", "CF1", "SR1", "CF1", "CF1"])
    assert Checkout.total(cart) == 30.57
  end
end
