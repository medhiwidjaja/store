defmodule Store.Checkout.Server do
  @moduledoc """
  Checkout module
  """
  use GenServer

  @registry Store.Registry

  alias Store.{Cart, Products, Discounts, PricingRule}

  ### client process

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(name) do
    cart = Store.Cart.new()
    GenServer.start_link(__MODULE__, [cart], name: via_tuple(name))
  end

  # via_tuple - private function used to register players in the GameServer Registry
  defp via_tuple(name) do
    {:via, Registry, {@registry, name}}
  end

  def add(name, code) do
    GenServer.call(via_tuple(name), {:add, code})
  end

  def apply_discount(name) do
    GenServer.call(via_tuple(name), :apply_discount)
  end

  def total(name) do
    GenServer.call(via_tuple(name), :total)
  end

  ## Server Callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:add, code}, _from, state) do
    [cart] = state
    {:reply, :ok, [code |> add_one(cart)]}
  end

  @impl true
  def handle_call(:apply_discount, _from, state) do
    [cart] = state

    items =
      cart.items
      |> Enum.map(fn {code, item} ->
        %{type: type, parameters: params} = Discounts.lookup(code)
        {code, PricingRule.apply(type, item, params)}
      end)

    {:reply, :ok, [%Cart{cart | items: items}]}
  end

  @impl true
  def handle_call(:total, _from, [cart] = state) do
    total = Cart.total(cart)
    {:reply, total, state}
  end

  ## Helper functions

  defp add_one(code, cart) do
    case Products.lookup(code) do
      nil ->
        [cart]

      product ->
        cart
        |> Cart.add(product)
    end
  end

  # defp format_pound(num) do
  #   "£#{:io_lib.format("~.2f", [num])}"
  # end
end