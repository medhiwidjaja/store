defmodule Store.Promotions do
  use Agent

  @me __MODULE__
  alias Store.Promotions.Promotion

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: @me)
  end

  def create_promotion(attrs \\ []) do
    case Promotion.new(attrs) do
      {:ok, promotion} ->
        :ok =
          Agent.update(@me, fn promotions ->
            promotions |> Map.put_new(promotion.code, promotion)
          end)

        {:ok, promotion}

      error ->
        error
    end
  end

  def list_promotions do
    Agent.get(@me, & &1)
  end

  def get_promotion(code) do
    list_promotions() |> Map.get(code)
  end
end
