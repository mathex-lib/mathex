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
end
