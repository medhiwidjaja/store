defmodule Store.ProductTest do
  use ExUnit.Case

  describe "products" do
    alias Store.{Products, Products.Product}

    @valid_attrs %{code: "GR1", name: "Green tea", price: 3.11}
    @missing_code %{name: "Green tea", price: 3.11}
    @missing_name %{code: "GR1", name: "", price: 3.11}
    @missing_price %{code: "GR1", name: ""}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.price == 3.11
    end

    test "create_product/1 with invalid data returns an error" do
      assert {:error, _} = Products.create_product(@missing_code)
      assert {:error, _} = Products.create_product(@missing_name)
      assert {:error, _} = Products.create_product(@missing_price)
    end
  end
end
