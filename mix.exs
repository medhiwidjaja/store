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
      dialyzer: dialyzer(),
      test_coverage: test_coverage(),
      preferred_cli_env: preferred_cli_env(),
      elixirc_paths: elixirc_paths(Mix.env()),
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
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.26", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14", only: :test}
    ]
  end

  defp dialyzer do
    [
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp test_coverage do
    [
      tool: ExCoveralls
    ]
  end

  defp preferred_cli_env do
    [
      "coveralls.detail": :test,
      "coveralls.html": :test,
      "coveralls.json": :test,
      coveralls: :test
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]

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
