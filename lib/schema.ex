defmodule Knit.Schema do
  @moduledoc """
  Sets up schemas.
  """

  defmacro __using__(_) do
    quote do
      @behaviour Knit.Model
      import Knit.Schema, only: [schema: 1]
    end
  end

  @doc """
  Register a schema for the module.
  """
  defmacro schema(do: block) do
    quote do
      fields = unquote(block)
      struct_keys = Map.keys(fields)

      @doc """
      Returns the schema map.
      """
      def schema do
        unquote(block)
      end

      # Add a struct to the calling module.
      Module.eval_quoted __ENV__, [
        Knit.Schema.__defstruct__(struct_keys)
      ]
    end
  end

  @doc false
  def __defstruct__(struct_keys) do
    quote do
      defstruct unquote(Macro.escape(struct_keys))
    end
  end
end
