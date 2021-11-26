defmodule Store.PricingRules do
  use Agent

  @me __MODULE__

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: @me)
  end

  def add_rule(name, func) when is_atom(name) and is_function(func) do
    Agent.update(@me, fn rules ->
      rules |> Map.put_new(name, func)
    end)
  end

  def add_rule(_, _) do
    :error
  end

  def list_rules do
    Agent.get(@me, & &1)
  end

  def get_rule(name) do
    list_rules() |> Map.get(name)
  end
end
