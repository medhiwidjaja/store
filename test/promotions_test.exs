defmodule Store.PromotionsTest do
  use ExUnit.Case

  describe "promotions" do
    alias Store.{Promotions, Promotions.Promotion}

    @valid_attrs %{code: "SR1", rule: :bulk, opts: [min_qty: 3, discounted_price: 4.50]}
    @new_attrs %{code: "CF1", rule: :buy_one_get_one}

    # setup do
    #   {:ok, _} = Promotions.start_link(%{"SR1" => @valid_attrs})
    #   :ok
    # end

    test "list_promotions/0 returns all promotions" do
      {:ok, _} = Promotions.start_link(%{"SR1" => @valid_attrs})
      assert Promotions.list_promotions() === %{"SR1" => @valid_attrs}
    end

    test "create_promotion/1 with valid data creates a promotion" do
      {:ok, _} = Promotions.start_link(%{})
      assert {:ok, %Promotion{} = promotion} = Promotions.create_promotion(@new_attrs)
      assert promotion.code == "CF1"
      assert promotion.rule == :buy_one_get_one

      assert Promotions.list_promotions() === %{
               "CF1" => %Promotion{code: "CF1", rule: :buy_one_get_one}
             }
    end

    test "get_promotion!/1 returns the promotion with given code" do
      {:ok, _} = Promotions.start_link(%{})
      assert {:ok, %Promotion{}} = Promotions.create_promotion(@valid_attrs)

      assert Promotions.get_promotion("SR1") == %Promotion{
               code: "SR1",
               rule: :bulk,
               opts: [min_qty: 3, discounted_price: 4.50]
             }
    end

    test "create promotion with no options" do
      {:ok, _} = Promotions.start_link(%{})
      assert {:ok, %Promotion{}} = Promotions.create_promotion(@new_attrs)

      assert Promotions.get_promotion("CF1") == %Promotion{
               code: "CF1",
               rule: :buy_one_get_one
             }
    end
  end
end
