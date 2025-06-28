defmodule Mathex.Structs.Matrix do
  defstruct data: []

  @type t :: %__MODULE__{data: list(list(number))}
end
