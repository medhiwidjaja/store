defmodule Store.Checkout do
  use GenServer
  alias Store.Products

  @me __MODULE__

  ## Client API

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, name: @me)
  end

  def scan(basket, code) do
    GenServer.call(basket, {:scan, code})
  end

  def list(basket) do
    GenServer.call(basket, :list)
  end

  ## Server Callbacks

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:scan, codes}, _from, state) when is_list(codes) do
    {:reply, :ok,
     codes
     |> Enum.reduce(state, fn code, acc -> add_one(code, acc) end)}
  end

  @impl true
  def handle_call({:scan, code}, _from, state) do
    {:reply, :ok, code |> add_one(state)}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  ## Helper functions

  defp add_one(code, state) do
    product = Products.get_product_by_code!(code)
    Map.update(state, code, {product, 1}, &{elem(&1, 0), elem(&1, 1) + 1})
  end
end
