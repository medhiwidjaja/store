defmodule Store.Products.Product do
  defstruct code: :empty, name: :empty, price: :empty

  def new(%{code: code, name: name, price: price})
      when is_binary(code) and byte_size(code) > 0 and
             is_binary(name) and byte_size(name) > 0 and
             is_float(price) do
    {:ok, %__MODULE__{code: code, name: name, price: price}}
  end

  def new(_), do: {:error, "Arguments error"}
end
