defmodule Store.Products do
  use Agent

  @me __MODULE__
  alias Store.Products.Product

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: @me)
  end

  def create_product(attrs \\ []) do
    case Product.new(attrs) do
      {:ok, product} ->
        :ok =
          Agent.update(@me, fn products ->
            products |> Map.put_new(product.code, product)
          end)

        {:ok, product}

      error ->
        error
    end
  end

  def list_products do
    Agent.get(@me, & &1)
  end

  def get_product_by_code(code) do
    list_products() |> Map.get(code)
  end
end
