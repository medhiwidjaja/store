defmodule Store.Products do
  alias Store.Products.Product

  def create_product(attrs \\ []) do
    Product.new(attrs)
  end
end
