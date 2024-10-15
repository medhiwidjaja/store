defmodule Store do
  use Application

  @impl true
  def start(_type, _args) do
    initialize_ets_tables()
    Store.Products.load()
    Store.Discounts.load()

    children = [
      {Registry, keys: :unique, name: Store.Registry},
      Store.Checkout.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Store.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp initialize_ets_tables() do
    # Create the ETS table for products and discounts
    product_ets_table = Application.fetch_env!(:store, :product_ets)

    discount_ets_table =
      Application.fetch_env!(:store, :discount_ets)

    :ets.new(product_ets_table, [:set, :public, :named_table])
    :ets.new(discount_ets_table, [:set, :public, :named_table])
  end
end
