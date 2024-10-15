defmodule Store.CartTest do
  use ExUnit.Case, async: true

  doctest Store.Cart

  alias Store.{Cart, Product}

  describe "Adding product to a Cart" do
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

  describe "Removing product from a Cart" do
    setup do
      product = Product.new("tea", "Tea", Decimal.new("2"))
      {:ok, product: product}
    end

    test "removes a product from the cart", %{product: product} do
      before = %Cart{
        items: %{
          "tea" => %{
            product: %Store.Product{code: "tea", name: "Tea", price: Decimal.new("2")},
            qty: 2,
            line_total: Decimal.new("4")
          }
        }
      }

      expected_result = %Cart{
        items: %{
          "tea" => %{
            product: %Store.Product{code: "tea", name: "Tea", price: Decimal.new("2")},
            qty: 1,
            line_total: Decimal.new("2")
          }
        }
      }

      cart = Cart.new() |> Cart.add(product) |> Cart.add(product)
      assert before == cart

      updated_cart = Cart.remove(cart, product)
      assert updated_cart == expected_result
    end

    test "removes the line item completly when qty reaches 0", %{product: product} do
      expected_result = %Cart{
        items: %{}
      }

      cart = Cart.new() |> Cart.add(product)

      updated_cart = Cart.remove(cart, product)
      assert updated_cart == expected_result
    end
  end

  describe "Calculating total" do
    setup do
      tea = Product.new("tea", "Tea", Decimal.new("2"))
      coffee = Product.new("coffee", "Coffee", Decimal.new("3"))
      cart = Cart.new() |> Cart.add(tea) |> Cart.add(tea) |> Cart.add(coffee)

      discount =
        Store.Discount.new(Store.PricingRule.BuyXGetYFree, %{
          name: "B1G1",
          code: "tea",
          x: 1,
          y: 1
        })

      {:ok, cart: cart, discount: discount}
    end

    test "calculates the total of items in the cart", %{cart: cart} do
      assert Cart.total(cart) == Decimal.new("7")
    end

    test "calculates the total with a discount applied", %{cart: cart, discount: discount} do
      cart = Store.Discount.apply(cart, discount)

      assert Cart.total(cart) == Decimal.new("5")
    end
  end
end
