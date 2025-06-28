defmodule Mathex do
  @moduledoc """
  Documentation for `Mathex`.
  """

  alias Mathex.Matrix

  defdelegate new!(data), to: Matrix
  defdelegate new(data), to: Matrix

  defdelegate transpose!(matrix), to: Matrix
  defdelegate transpose(matrix), to: Matrix

  defdelegate to_list(matrix), to: Matrix
end
