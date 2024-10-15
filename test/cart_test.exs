defmodule Store.CartTest do
  use ExUnit.Case, async: true

  doctest Store.Cart

  alias Store.{Cart, Product}

  describe "Cart" do
    setup do
      product = Product.new("tea", "Tea", Decimal.new("2"))
      {:ok, product: product}
    end

    test "adding a product to the cart", %{product: product} do
      expected_result = %Cart{
        items: %{
          "tea" => %{
            product: %Store.Product{code: "tea", name: "Tea", price: Decimal.new("2")},
            qty: 1,
            line_total: Decimal.new("2")
          }
        }
      }

      cart = Cart.new()
      updated_cart = Cart.add(cart, product)
      assert updated_cart == expected_result
    end

    test "adding the same product will update the quantity and line total", %{product: product} do
      expected_result = %Cart{
        items: %{
          "tea" => %{
            product: %Store.Product{code: "tea", name: "Tea", price: Decimal.new("2")},
            qty: 2,
            line_total: Decimal.new("4")
          }
        }
      }

      cart = Cart.new()
      updated_cart = Cart.add(cart, product)
      updated_cart = Cart.add(updated_cart, product)
      assert updated_cart == expected_result
    end

    test "adding multiple products", %{product: product} do
      coffee = Product.new("coffee", "Coffee", Decimal.new("3"))

      expected_result = %Cart{
        items: %{
          "tea" => %{
            product: %Store.Product{code: "tea", name: "Tea", price: Decimal.new("2")},
            qty: 1,
            line_total: Decimal.new("2")
          },
          "coffee" => %{
            product: %Store.Product{code: "coffee", name: "Coffee", price: Decimal.new("3")},
            qty: 1,
            line_total: Decimal.new("3")
          }
        }
      }

      cart = Cart.new()
      updated_cart = Cart.add(cart, product)
      updated_cart = Cart.add(updated_cart, coffee)
      assert updated_cart == expected_result
    end
  end
end
