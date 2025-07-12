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

  defdelegate scalar_multiply!(matrix, scalar), to: Matrix
  defdelegate scalar_multiply(matrix, scalar), to: Matrix

  defdelegate add!(matrix_one, matrix_two), to: Matrix
  defdelegate add(matrix_one, matrix_two), to: Matrix
end
