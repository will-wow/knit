defmodule Knit.IntegerType do
  use Knit.Type

  def convert(value) when is_integer(value), do: value
  def convert(value) when is_float(value), do: round(value)
  def convert(value) when is_binary(value) do
    case Integer.parse(value) do
      {int, _} -> int
      :error -> nil
    end
  end
end