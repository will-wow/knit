defmodule Knit.BooleanType do
  use Knit.Type

  def convert(true), do: true
  def convert(false), do: false
  def convert(0), do: false
  def convert(0.0), do: false
  def convert(value) when is_binary(value) do
    case String.downcase(value) do
      "false" -> false
      "" -> false
      _ -> true
    end
  end
  def convert(_), do: true
end