# Store

A simple checkout system that calculates the cost of a basket and applies
any special discounts or pricing rules.

You can create new pricing rules by creating a functiom in Elixir and register
them into the system.

You can then apply a pricing rule for a product.

## Installation

The package can be installed by adding `store` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:store, git: "https://github.com/medhiwidjaja/store"}
  ]
end
```

This package has no external dependencies.

## Usage

The system can be run from a REPL such as iex or you can include the package as a
library in a different project.

First setup your products and start the Products process. Here it is initialized with
some products.

Define some aliases:

```elixir
  alias Store.{Products, PricingRules, PricingRules.BuiltInRules, Promotions, Checkout}
```

```elixir
  gr1 = %{code: "GR1", name: "Green tea", price: 3.11}
  sr1 = %{code: "SR1", name: "Strawberries", price: 5.0}
  cf1 = %{code: "CF1", name: "Coffee", price: 11.23}

  Products.start_link(%{gr1.code => gr1, sr1.code => sr1, cf1.code => cf1})
```

And then start PricingRules. Some built-in rules are included that can be
used in the initialization of the PricingRules process:

```elixir
    PricingRules.start_link(%{
      bulk: &BuiltInRules.bulk_discount/2,
      fraction: &BuiltInRules.fraction_discount/2,
      buy1get1: &BuiltInRules.buy_one_get_one/1
    })
```

You can define your own rules, by defining a function and then use `PricingRules.create_rule` function to add it in the register.

For example 'Buy 2 Get 1 Free' rule can be defined as follows:

```elixir
    PricingRules.add_rule(:buy2get1, fn {%{price: price} = p, qty} ->
      {p, qty, (2*div(qty, 3) + rem(qty, 3)) * price}
    end)
```

And then you need to define the current store promotions. Here's an example of how to
add some rules using rules that are already registered.

```elixir
    Promotions.start_link(%{
      "GR1" => %Promotion{code: "GR1", rule: :buy1get1},
      "SR1" => %Promotion{code: "SR1", rule: :bulk, opts: [min_qty: 3, discounted_price: 4.50]},
      "CF1" => %Promotion{code: "CF1", rule: :fraction, opts: [min_qty: 3, multiplier: 2.0 / 3.0]}
    })
```

Lastly, you need to start the process `Checkout` to start scanning product codes and
calculating the totals.

```elixir
  {:ok, cart} = Checkout.start_link()
  Checkout.scan(cart, ["GR1", "SR1", "GR1", "GR1", "CF1"])
  total = Checkout.total(cart)
```

## Future Improvements

- Right now products are stored in an Agent that stores products list as it's
  internal state. In a real system these would be held as a table in a database and accessed that way.

- Product prices should ideally be represented using Decimal library to better
  accuracy in calculations as calculation using float for currencies may introduce
  rounding off errors.

## Running Tests

To run the test suite, simply run `mix test` from the root directory.

```
$ mix test
```
