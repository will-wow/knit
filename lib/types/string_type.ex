defmodule Knit.StringType do
  use Knit.Type

  def convert(value) when is_binary(value), do: value
  def convert(value), do: inspect(value)
end