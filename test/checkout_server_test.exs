defmodule Store.Checkout.ServerTest do
  use ExUnit.Case

  alias Store.Checkout.Server

  @checkout_line "Checkout Line 1"
  setup do
    start_checkout_server(:no1, @checkout_line)

    :ok
  end

  describe "Assigned task scenarios" do
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
  end

  describe "Additional scenarios" do
    test "removing product from cart should result in correct total" do
      ~w{GR1 SR1 GR1 GR1 CF1}
      |> Enum.each(&Server.add(@checkout_line, &1))

      Server.apply_discount(@checkout_line)
      assert Decimal.eq?(Server.total(@checkout_line), Decimal.new("22.45"))

      Server.remove(@checkout_line, "GR1")
      Server.apply_discount(@checkout_line)
      assert Decimal.eq?(Server.total(@checkout_line), Decimal.new("19.34"))
    end

    test "adding items in any order result in same answer" do
      ~w{GR1 SR1 GR1 GR1 CF1}
      |> Enum.each(&Server.add(@checkout_line, &1))

      Server.apply_discount(@checkout_line)
      a = Server.total(@checkout_line)

      # Start another checkout line process
      start_checkout_server(:no2, "line 2")

      ~w{SR1 GR1 CF1 GR1 GR1}
      |> Enum.each(&Server.add("line 2", &1))

      Server.apply_discount("line 2")
      b = Server.total("line 2")

      assert Decimal.eq?(a, b)
    end
  end

  defp start_checkout_server(id, name) do
    child_spec = %{
      id: id,
      start: {Store.Checkout.Server, :start_link, [name]},
      restart: :temporary
    }

    start_supervised!(child_spec)
  end
end
