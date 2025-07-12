defmodule Mathex.MatrixValidators do
  @moduledoc """
  Provides validation functions for verifying the structural integrity of matrices.

  All functions return `:ok` on success or `{:error, reason}` on failure.

  These validations are intended to be composed into higher-level workflows,
  such as `Mathex.Matrix.new/1` or other matrix operations that depend on valid input.
  """

  alias Mathex.Structs.Matrix

  @doc """
  Validates that the input is a list of lists.

  Returns `:ok` if all elements in the outer list are themselves lists.

  ## Examples
      iex> Mathex.MatrixValidators.validate_is_list_of_lists([[1, 2], [3, 4]])
      :ok

      iex> Mathex.MatrixValidators.validate_is_list_of_lists([1, 2, 3])
      {:error, "Matrix must be a list of lists"}
  """
  @spec validate_is_list_of_lists([[number()]]) :: :ok | {:error, String.t()}
  def validate_is_list_of_lists(data) do
    if is_list(data) and Enum.all?(data, fn row -> is_list(row) end) do
      :ok
    else
      {:error, "Matrix must be a list of lists"}
    end
  end

  @doc """
  Validates that the matrix is not empty.

  Returns `:ok` if the outer list has at least one row.

  ## Examples
      iex> Mathex.MatrixValidators.validate_non_empty([[1, 2]])
      :ok

      iex> Mathex.MatrixValidators.validate_non_empty([])
      {:error, "Matrix must have at least one row"}
  """
  @spec validate_non_empty([[number()]]) :: :ok | {:error, String.t()}
  def validate_non_empty(data) do
    if length(data) > 0 do
      :ok
    else
      {:error, "Matrix must have at least one row"}
    end
  end

  @doc """
  Validates that all rows have the same number of columns.

  Returns `:ok` if all inner lists are of equal length.

  ## Examples
      iex> Mathex.MatrixValidators.validate_uniform_columns([[1, 2], [3, 4]])
      :ok

      iex> Mathex.MatrixValidators.validate_uniform_columns([[1], [2, 3]])
      {:error, "All rows must have the same number of columns"}
  """
  @spec validate_uniform_columns([[number()]]) :: :ok | {:error, String.t()}
  def validate_uniform_columns([first_row | rest]) do
    expected_column_length = length(first_row)

    if Enum.all?(rest, fn row -> length(row) == expected_column_length end) do
      :ok
    else
      {:error, "All rows must have the same number of columns"}
    end
  end

  @doc """
  Validates that rows have at least one column.

  Returns `:ok` if the first row has one or more elements.

  ## Examples
      iex> Mathex.MatrixValidators.validate_non_empty_columns([[1, 2], [3, 4]])
      :ok

      iex> Mathex.MatrixValidators.validate_non_empty_columns([[]])
      {:error, "Rows should have at least one column"}
  """
  @spec validate_non_empty_columns([[number()]]) :: :ok | {:error, String.t()}
  def validate_non_empty_columns(data) do
    if Enum.all?(data, fn row -> length(row) > 0 end) do
      :ok
    else
      {:error, "Rows should have at least one column"}
    end
  end

  @doc """
  Validates that two matrices have the same dimensions.

  Returns `:ok` if both matrices have the same number of rows and columns..

  ## Examples
      iex> m1 = Mathex.Matrix.new!([[1, 2], [3, 4]])
      iex> m2 = Mathex.Matrix.new!([[5, 6], [7, 8]])
      iex> Mathex.MatrixValidators.validate_equal_dimensions(m1, m2)
      :ok

      iex> m1 = Mathex.Matrix.new!([[1, 2], [3, 4]])
      iex> m2 = Mathex.Matrix.new!([[1, 2, 3], [4, 5, 6]])
      iex> Mathex.MatrixValidators.validate_equal_dimensions(m1, m2)
      {:error, "Matrices should have the same dimension"}
  """
  @spec validate_equal_dimensions(Matrix.t(), Matrix.t()) :: :ok | {:error, String.t()}
  def validate_equal_dimensions(%Matrix{data: data_one}, %Matrix{data: data_two}) do
    dimension_one = {length(data_one), length(List.first(data_one))}
    dimension_two = {length(data_two), length(List.first(data_two))}

    if dimension_one == dimension_two do
      :ok
    else
      {:error, "Matrices should have the same dimension"}
    end
  end
end
