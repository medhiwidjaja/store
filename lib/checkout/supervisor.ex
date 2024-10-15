defmodule Store.Checkout.Supervisor do
  use DynamicSupervisor

  alias Store.Checkout.Server

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_checkout(name) do
    child_spec = %{
      id: Checkout,
      start: {Server, :start_link, [name]},
      restart: :temporary
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
