defmodule Store.PromotionsTest do
  use ExUnit.Case

  describe "promotions" do
    alias Store.{Promotions, Promotions.Promotion}

    @valid_attrs %{code: "SR1", rule: :bulk, opts: [min_qty: 3, discounted_price: 4.50]}

    setup do
      {:ok, _} = Promotions.start_link(%{"SR1" => @valid_attrs})
      :ok
    end

    test "list_promotions/0 returns all promotions" do
      assert Promotions.list_promotions() === %{"SR1" => @valid_attrs}
    end

    test "create_promotion/1 with valid data creates a promotion" do
      assert {:ok, %Promotion{} = promotion} = Promotions.create_promotion(@valid_attrs)
      assert promotion.code == "SR1"
    end

    test "get_promotion!/1 returns the promotion with given code" do
      assert Promotions.get_promotion("SR1") == @valid_attrs
    end
  end
end
