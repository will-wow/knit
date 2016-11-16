defmodule Knit.Type do
  @moduledoc """
  The Type behavior
  """

  @callback convert(any) :: any

  defmacro __using__(_) do
    quote do
      @behaviour Knit.Type
    end
  end
end
