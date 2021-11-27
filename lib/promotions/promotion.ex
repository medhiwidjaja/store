defmodule Store.Promotions.Promotion do
  defstruct code: :empty, rule: :empty, opts: :empty

  def new(%{code: code, rule: rule, opts: opts})
      when is_binary(code) and is_atom(rule) do
    {:ok, %__MODULE__{code: code, rule: rule, opts: opts}}
  end

  def new(%{code: code, rule: rule})
      when is_binary(code) and is_atom(rule) do
    {:ok, %__MODULE__{code: code, rule: rule}}
  end

  def new(_), do: {:error, "Arguments error"}
end
