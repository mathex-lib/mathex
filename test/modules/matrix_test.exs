defmodule Mathex.MatrixTest do
  use ExUnit.Case

  import Mathex.Matrix

  alias Mathex.Structs.Matrix
  alias Mathex.Errors.Matrix.InvalidMatrixError

  doctest Mathex.Matrix

  describe "new!/1" do
    test "returns a new Matrix struct" do
      input = [[1, 2], [3, 4]]

      matrix = new!(input)

      assert %Matrix{} = matrix
      assert matrix.data == input
    end

    test "raises InvalidMatrixError when input is not a list of lists" do
      assert_raise InvalidMatrixError, "Matrix must be a list of lists", fn ->
        new!(["not", "a", "valid", "matrix"])
      end
    end

    test "raises InvalidMatrixError when input is an empty list" do
      assert_raise InvalidMatrixError, "Matrix must have at least one row", fn ->
        new!([])
      end
    end

    test "raises InvalidMatrixError when input has different column sizes" do
      assert_raise InvalidMatrixError, "All rows must have the same number of columns", fn ->
        new!([[1, 2], [3], [4, 5]])
      end
    end

    test "raises InvalidMatrixError when input has empty columns" do
      assert_raise InvalidMatrixError, "Rows should have at least one column", fn ->
        new!([[], []])
      end
    end
  end

  describe "new/1" do
    test "returns success tuple with a new Matrix struct" do
      input = [[1, 2], [3, 4]]

      {:ok, matrix} = new(input)

      assert %Matrix{} = matrix
      assert matrix.data == input
    end

    test "returns error tuple when input is not a list of lists" do
      result = new(["not", "a", "valid", "matrix"])

      assert {:error, reason} = result
      assert reason == "Matrix must be a list of lists"
    end

    test "returns error tuple when input is an empty list" do
      result = new([])

      assert {:error, reason} = result
      assert reason == "Matrix must have at least one row"
    end

    test "returns error tuple when input has different column sizes" do
      result = new([[1, 2], [3], [4, 5]])

      assert {:error, reason} = result
      assert reason == "All rows must have the same number of columns"
    end

    test "returns error tuple when input has empty columns" do
      result = new([[], []])

      assert {:error, reason} = result
      assert reason == "Rows should have at least one column"
    end
  end

  describe "transpose!/1" do
    test "returns the transposed matrix" do
      matrix = new!([[1, 2], [3, 4]])
      transposed = transpose!(matrix)

      assert %Matrix{} = transposed
      assert transposed.data == [[1, 3], [2, 4]]
    end

    test "raises InvalidMatrixError when input is not a Matrix struct" do
      assert_raise InvalidMatrixError, "Invalid matrix input. Use Mathex.Matrix.new/1.", fn ->
        transpose!([[1, 2], [3, 4]])
      end
    end
  end

  describe "transpose/1" do
    test "returns success tuple with the transposed matrix" do
      matrix = new!([[1, 2], [3, 4]])
      {:ok, transposed} = transpose(matrix)

      assert %Matrix{} = transposed
      assert transposed.data == [[1, 3], [2, 4]]
    end

    test "returns error tuple when input is not a valid matrix" do
      result = transpose([[1, 2], [3, 4]])

      assert {:error, reason} = result
      assert reason == "Invalid matrix input. Use Mathex.Matrix.new/1."
    end
  end

  describe "to_list/1" do
    test "converts a Matrix struct into an Elixir list" do
      matrix = new!([[1, 2], [3, 4]])
      list = to_list(matrix)

      assert is_list(list) == true
      assert list == [[1, 2], [3, 4]]
    end

    test "returns the input as is if it's not a Matrix struct" do
      input = "NOT_A_MATRIX"
      result = to_list(input)

      assert is_binary(result) == true
      assert result == "NOT_A_MATRIX"
    end
  end

  describe "scalar_multiply!/2" do
    test "successfully multiplies all matrix elements by the scalar" do
      matrix = new!([[1, 2], [3, 4]])
      result = scalar_multiply!(matrix, 5)

      assert %Matrix{} = result
      assert result.data == [[5, 10], [15, 20]]
    end

    test "raises ArithmeticError when the scalar is not a number" do
      matrix = new!([[1, 2], [3, 4]])

      assert_raise ArithmeticError, "Scalar must be a number", fn ->
        scalar_multiply!(matrix, "3")
      end
    end

    test "raises InvalidMatrixError when matrix is not a Matrix struct" do
      assert_raise InvalidMatrixError, "Invalid matrix input. Use Mathex.Matrix.new/1.", fn ->
        scalar_multiply!([[1, 2], [3, 4]], 3)
      end
    end

    test "raises InvalidMatrixError when both inputs are wrong" do
      assert_raise InvalidMatrixError, "Invalid matrix input. Use Mathex.Matrix.new/1.", fn ->
        scalar_multiply!("NOT_A_MATRIX", "3")
      end
    end
  end

  describe "scalar_multiply/2" do
    test "successfully multiplies all matrix elements by the scalar" do
      matrix = new!([[1, 2], [3, 4]])
      {:ok, result} = scalar_multiply(matrix, 5)

      assert %Matrix{} = result
      assert result.data == [[5, 10], [15, 20]]
    end

    test "returns error tuple when the scalar is not a number" do
      matrix = new!([[1, 2], [3, 4]])
      result = scalar_multiply(matrix, "3")

      assert {:error, reason} = result
      assert reason == "Scalar must be a number"
    end

    test "returns error tuple when martix is not a Matrix struct" do
      matrix = [[1, 2], [3, 4]]
      result = scalar_multiply(matrix, 3)

      assert {:error, reason} = result
      assert reason == "Invalid matrix input. Use Mathex.Matrix.new/1."
    end

    test "returns error tuple when both inputs are wrong" do
      matrix = [[1, 2], [3, 4]]
      result = scalar_multiply(matrix, "3")

      assert {:error, reason} = result
      assert reason == "Invalid matrix input. Use Mathex.Matrix.new/1."
    end
  end

  describe "add!/2" do
    test "successfully adds two matrices together" do
      matrix_one = new!([[1, 2], [3, 4]])
      matrix_two = new!([[2, 2], [4, 4]])

      result = add!(matrix_one, matrix_two)

      assert %Matrix{} = result
      assert result.data == [[3, 4], [7, 8]]
    end

    test "raises InvalidMatrixError matrices have different dimensions" do
      assert_raise InvalidMatrixError, "Matrices should have the same dimension", fn ->
        matrix_one = new!([[1, 2], [3, 4]])
        matrix_two = new!([[2, 2, 2, 2], [4, 4, 4, 4]])

        add!(matrix_one, matrix_two)
      end
    end

    test "raises InvalidMatrixError when first input is not a Matrix struct" do
      assert_raise InvalidMatrixError, "Invalid matrix input. Use Mathex.Matrix.new/1.", fn ->
        matrix = new!([[1, 2], [3, 4]])

        add!(matrix, [[1, 2], [3, 4]])
      end
    end

    test "raises InvalidMatrixError when second input is not a Matrix struct" do
      assert_raise InvalidMatrixError, "Invalid matrix input. Use Mathex.Matrix.new/1.", fn ->
        matrix = new!([[1, 2], [3, 4]])

        add!("NOT_A_MATRIX", matrix)
      end
    end

    test "raises InvalidMatrixError when both inputs are not a Matrix struct" do
      assert_raise InvalidMatrixError, "Invalid matrix input. Use Mathex.Matrix.new/1.", fn ->
        add!("NOT_A_MATRIX", [[1, 2], [3, 4]])
      end
    end
  end

  describe "add/2" do
    test "successfully adds two matrices together" do
      matrix_one = new!([[1, 2], [3, 4]])
      matrix_two = new!([[2, 2], [4, 4]])

      {:ok, matrix} = add(matrix_one, matrix_two)

      assert %Matrix{} = matrix
      assert matrix.data == [[3, 4], [7, 8]]
    end

    test "returns error tuple matrices have different dimensions" do
      matrix_one = new!([[1, 2], [3, 4]])
      matrix_two = new!([[2, 2, 2, 2], [4, 4, 4, 4]])

      result = add(matrix_one, matrix_two)

      assert {:error, reason} = result
      assert reason == "Matrices should have the same dimension"
    end

    test "returns error tuple when first input is not a Matrix struct" do
      matrix = new!([[1, 2], [3, 4]])

      result = add(matrix, [[1, 2], [3, 4]])

      assert {:error, reason} = result
      assert reason == "Invalid matrix input. Use Mathex.Matrix.new/1."
    end

    test "returns error tuple when second input is not a Matrix struct" do
      matrix = new!([[1, 2], [3, 4]])

      result = add("NOT_A_MATRIX", matrix)

      assert {:error, reason} = result
      assert reason == "Invalid matrix input. Use Mathex.Matrix.new/1."
    end

    test "returns error tuple when both inputs are not a Matrix struct" do
      result = add("NOT_A_MATRIX", [[1, 2], [3, 4]])

      assert {:error, reason} = result
      assert reason == "Invalid matrix input. Use Mathex.Matrix.new/1."
    end
  end
end
