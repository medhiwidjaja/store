defmodule Store.MixProject do
  use Mix.Project

  def project do
    [
      app: :store,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Store",
      source_url: "https://github.com/medhiwidjaja/store"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def description() do
    """
    A simple checkout system that calculates the cost of a basket and applies
    any special discounts or pricing rules.

    You can create new pricing rules by creating a functiom in Elixir and register
    them into the system.

    You can then apply a pricing rule for a product.
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      name: :store,
      maintainers: ["Medhi Widjaja"],
      links: %{
        "Github" => "https://github.com/medhiwidjaja/store"
      }
    ]
  end
end
