defmodule Store.CheckoutTest do
  use ExUnit.Case

  alias Store.Checkout
  alias Store.Products
  alias Store.Promotions
  alias Store.{PricingRules, PricingRules.BuiltInRules}

  @gr1 %{code: "GR1", name: "Green tea", price: 3.11}
  @sr1 %{code: "SR1", name: "Strawberries", price: 5.0}
  @cf1 %{code: "CF1", name: "Coffee", price: 11.23}

  setup do
    Products.start_link(%{@gr1.code => @gr1, @sr1.code => @sr1, @cf1.code => @cf1})
    :ok
  end

  describe "scanning single products" do
    test "scanning a code adds the product to the basket" do
      {:ok, cart} = Checkout.start_link(%{})

      Checkout.scan(cart, "SR1")
      Checkout.scan(cart, "SR1")
      Checkout.scan(cart, "CF1")
      assert Checkout.list(cart) == %{@sr1.code => {@sr1, 2}, @cf1.code => {@cf1, 1}}
    end
  end

  describe "scanning a list of products" do
    test "scanning a lsit of codes adds the products to the basket" do
      {:ok, cart} = Checkout.start_link(%{})

      Checkout.scan(cart, ["GR1", "SR1", "GR1"])
      assert Checkout.list(cart) == %{@gr1.code => {@gr1, 2}, @sr1.code => {@sr1, 1}}
    end
  end

  describe "calculating totals" do
    setup do
      {:ok, basket} = Checkout.start_link(%{})
      {:ok, _rules} = PricingRules.start_link(%{bulk: &BuiltInRules.bulk_discount/2})
      {:ok, _promotions} = Promotions.start_link(%{})
      Checkout.scan(basket, ["SR1", "SR1", "SR1"])
      {:ok, basket: basket}
    end

    test "without applying discount rules", %{basket: basket} do
      assert Checkout.total(basket) == "£15.00"
    end

    test "with applying discount rules", %{basket: basket} do
      Promotions.create_promotion(%{
        code: "SR1",
        rule: :bulk,
        opts: [min_qty: 3, discounted_price: 4.50]
      })

      assert Checkout.total(basket) == "£13.50"
    end
  end
end
