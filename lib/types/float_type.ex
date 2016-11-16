defmodule Knit.FloatType do
  use Knit.Type

  def convert(value) when is_float(value), do: value
  def convert(value) when is_integer(value), do: value / 1
  def convert(value) when is_binary(value) do
    case Float.parse(value) do
      {int, _} -> int
      :error -> nil
    end
  end
end