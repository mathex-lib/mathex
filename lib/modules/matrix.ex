defmodule Mathex.Matrix do
  @moduledoc """
  This module provides the core API for creating and working with matrices.

  This module serves as the main entry point for all matrix-related operations in Mathex,
  including creation, validation, transformation, and arithmetic.

  All matrix values are wrapped in the `%Matrix{}` struct defined in `Mathex.Structs.Matrix`.
  """
  alias Mathex.Structs.Matrix
  alias Mathex.Errors.Matrix.InvalidMatrixError
  alias Mathex.MatrixValidators, as: Validators

  @doc """
  Creates a new matrix from a 2D list, returning a `%Matrix{}` struct.

  If validation fails, it raises `Mathex.Errors.Matrix.InvalidMatrixError`.
  """
  @spec new!([[number()]]) :: Matrix.t()
  def new!(data) do
    case create_new_matrix(data) do
      {:ok, matrix} -> matrix
      {:error, reason} -> raise InvalidMatrixError, message: reason
    end
  end

  @doc """
  Creates a new matrix from a 2D list.

  Returns `{:ok, matrix}` if the input passes validation, or
  `{:error, reason}` if it fails.

  This is the non-raising counterpart to `new!/1`.
  """
  @spec new([[number()]]) :: {:ok, Matrix.t()} | {:error, String.t()}
  def new(data) do
    create_new_matrix(data)
  end

  @doc false
  @spec create_new_matrix([[number()]]) :: {:ok, Matrix.t()} | {:error, String.t()}
  defp create_new_matrix(data) do
    with :ok <- Validators.validate_is_list_of_lists(data),
         :ok <- Validators.validate_non_empty(data),
         :ok <- Validators.validate_uniform_columns(data),
         :ok <- Validators.validate_non_empty_columns(data) do
      {:ok, %Matrix{data: data}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Returns the transpose of a matrix.

  Flips the matrix over its diagonal, turning rows into columns and vice versa.
  Raises `InvalidMatrixError` if the input is not a valid matrix.

  This is the raising counterpart to `transpose/1`.
  """
  @spec transpose!(Matrix.t()) :: Matrix.t()
  def transpose!(%Matrix{} = matrix) do
    {:ok, matrix} = transpose_matrix(matrix)
    matrix
  end

  def transpose!(_invalid), do: raise(InvalidMatrixError)

  @doc """
  Returns the transpose of a matrix without raising.

  Returns `{:ok, matrix}` if the input is a valid `%Matrix{}` struct,
  or `{:error, reason}` otherwise.

  This is the safe counterpart to `transpose!/1`.
  """
  @spec transpose(Matrix.t()) :: {:ok, Matrix.t()} | {:error, String.t()}
  def transpose(%Matrix{} = matrix) do
    transpose_matrix(matrix)
  end

  def transpose(_invalid), do: {:error, InvalidMatrixError.exception(%{}).message}

  @doc false
  @spec transpose_matrix(Matrix.t()) :: {:ok, Matrix.t()}
  defp transpose_matrix(%Matrix{data: data}) do
    transposed =
      data
      |> Enum.zip()
      |> Enum.map(fn row -> Tuple.to_list(row) end)

    {:ok, %Matrix{data: transposed}}
  end

  @doc """
  Extracts the raw 2D list data from a matrix.

  This is useful when you want to work with the underlying list
  representation directly or interoperate with functions that expect plain lists.
  """
  @spec to_list(Matrix.t()) :: [[number()]]
  def to_list(%Matrix{data: data}), do: data

  def to_list(other), do: other

  @doc """
  Multiplies a matrix by a scalar value.

  Returns a new `Matrix` struct. Raises `ArithmeticError` if the scalar is not a number,
  or `InvalidMatrixError` if the input is not a valid `Matrix`.
  """
  @spec scalar_multiply!(Matrix.t(), number()) :: Matrix.t()
  def scalar_multiply!(%Matrix{} = matrix, scalar) when is_number(scalar) do
    {:ok, matrix} = multiply_matrix_with_scalar(matrix, scalar)
    matrix
  end

  def scalar_multiply!(%Matrix{}, _invalid), do: raise(ArithmeticError, "Scalar must be a number")

  def scalar_multiply!(_invalid, _scalar), do: raise(InvalidMatrixError)

  @doc """
  Multiplies a matrix by a scalar value.

  Returns a new `Matrix` struct with each element multiplied by the scalar.
  Returns `{:ok, result}` on success, or `{:error, reason}` if input is invalid.
  """
  @spec scalar_multiply(Matrix.t(), number()) :: {:ok, Matrix.t()} | {:error, String.t()}
  def scalar_multiply(%Matrix{} = matrix, scalar) when is_number(scalar) do
    multiply_matrix_with_scalar(matrix, scalar)
  end

  def scalar_multiply(%Matrix{}, _invalid), do: {:error, "Scalar must be a number"}

  def scalar_multiply(_invalid, _scalar), do: {:error, InvalidMatrixError.exception(%{}).message}

  @doc false
  defp multiply_matrix_with_scalar(%Matrix{data: data}, scalar) do
    result =
      Enum.map(data, fn row ->
        Enum.map(row, fn col ->
          col * scalar
        end)
      end)

    {:ok, %Matrix{data: result}}
  end
end
