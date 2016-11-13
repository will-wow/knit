defmodule Knit.SchemaMacros do
  @moduledoc """
  Sets up schemas.
  """

  defmacro __using__(_) do
    quote do
      import Knit.Schema, only: [schema: 1]
    end
  end

  @doc """
  Register a schema for the module.
  """
  defmacro schema(do: block) do
    quote do
      Module.register_attribute(__MODULE__, :struct_fields, accumulate: true)
      Module.register_attribute(__MODULE__, :knit_fields, accumulate: true)

      import Knit.Schema
      unquote(block)

      Module.eval_quoted __ENV__, [
        Knit.Schema.__defstruct__(@struct_fields)
      ]
      
    end
  end

  @doc """
  Register a field for the schema.
  """
  defmacro field(name, type \\ :string, opts \\[]) do
    quote do
      Knit.Schema.__field__(__MODULE__, unquote(name), unquote(type), unquote(opts))
    end
  end

  @doc false
  def __field__(mod, name, type, opts) do
    # Add the field to the module struct.
    Module.put_attribute(mod, :struct_fields, {name, opts[:default] || nil})
    # Record the field type.
    Module.put_attribute(mod, :knit_fields, {name, type})
  end

  @doc false
  def __defstruct__(struct_fields) do
    quote do
      defstruct unquote(Macro.escape(struct_fields))
    end 
  end
end
