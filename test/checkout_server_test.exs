defmodule Store.Checkout.ServerTest do
  use ExUnit.Case

  alias Store.Checkout.Server

  @checkout_line "Checkout Line 1"
  setup do
    start_checkout_server(@checkout_line)

    :ok
  end

  test "Case 1" do
    ~w{GR1 SR1 GR1 GR1 CF1}
    |> Enum.each(&Server.add(@checkout_line, &1))

    Server.apply_discount(@checkout_line)

    assert Decimal.eq?(Server.total(@checkout_line), Decimal.new("22.45"))
  end

  test "Case 2" do
    ~w{GR1 GR1}
    |> Enum.each(&Server.add(@checkout_line, &1))

    Server.apply_discount(@checkout_line)

    assert Decimal.eq?(Server.total(@checkout_line), Decimal.new("3.11"))
  end

  test "Case 3" do
    ~w{SR1 SR1 GR1 SR1}
    |> Enum.each(&Server.add(@checkout_line, &1))

    Server.apply_discount(@checkout_line)

    assert Decimal.eq?(Server.total(@checkout_line), Decimal.new("16.61"))
  end

  test "Case 4" do
    ~w{GR1 CF1 SR1 CF1 CF1}
    |> Enum.each(&Server.add(@checkout_line, &1))

    Server.apply_discount(@checkout_line)

    assert Decimal.eq?(Server.total(@checkout_line), Decimal.new("30.57"))
  end

  defp start_checkout_server(name) do
    child_spec = %{
      id: Checkout,
      start: {Store.Checkout.Server, :start_link, [name]},
      restart: :temporary
    }

    start_supervised!(child_spec)
  end
end
