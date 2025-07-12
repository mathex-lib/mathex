defmodule Mathex.MatrixValidatorsTest do
  use ExUnit.Case

  import Mathex.MatrixValidators

  doctest Mathex.MatrixValidators

  describe "validate_is_list_of_lists/1" do
    test "returns :ok for valid lists of lists" do
      assert :ok = validate_is_list_of_lists([[1, 2], [3, 4]])
    end

    test "returns :ok for an empty list" do
      assert :ok = validate_is_list_of_lists([])
    end

    test "returns error for flat list" do
      assert {:error, reason} = validate_is_list_of_lists([1, 2, 3, 4])
      assert reason == "Matrix must be a list of lists"
    end

    test "returns error for non-list input" do
      assert {:error, reason} = validate_is_list_of_lists(:not_a_list)
      assert reason == "Matrix must be a list of lists"
    end

    test "returns error if one row is not a list" do
      assert {:error, reason} = validate_is_list_of_lists([[1, 2], 42])
      assert reason == "Matrix must be a list of lists"
    end
  end

  describe "validate_non_empty/1" do
    test "returns :ok for non empty list of lists" do
      assert :ok = validate_non_empty([[1, 2]])
    end

    test "returns :ok for a list with an empty list" do
      assert :ok = validate_non_empty([[]])
    end

    test "returns error for empty flat list" do
      assert {:error, reason} = validate_non_empty([])
      assert reason == "Matrix must have at least one row"
    end
  end

  describe "validate_uniform_columns/1" do
    test "returns :ok for list with uniform lists" do
      assert :ok = validate_uniform_columns([[1, 2], [3, 4]])
    end

    test "returns :ok for a list with an empty list" do
      assert :ok = validate_uniform_columns([[]])
    end

    test "returns :ok for a single row" do
      assert :ok = validate_uniform_columns([[1, 2, 3]])
    end

    test "returns error for list with different list sizes" do
      assert {:error, reason} = validate_uniform_columns([[1], [2, 3]])
      assert reason == "All rows must have the same number of columns"
    end
  end

  describe "validate_non_empty_columns/1" do
    test "returns :ok for a list with non empty lists" do
      assert :ok = validate_non_empty_columns([[1, 2], [3, 4]])
    end

    test "returns :ok for list with different list sizes" do
      assert :ok = validate_non_empty_columns([[1], [2, 3]])
    end

    test "returns error for a list with an empty list" do
      assert {:error, reason} = validate_non_empty_columns([[]])
      assert reason == "Rows should have at least one column"
    end

    test "returns error for at least one empty list" do
      assert {:error, reason} = validate_non_empty_columns([[1, 2], [], [4, 5]])
      assert reason == "Rows should have at least one column"
    end
  end

  describe "validate_equal_dimensions/2" do
    test "returns :ok when matrices have the same dimension" do
      matrix_one = Mathex.Matrix.new!([[1, 2, 3], [1, 2, 3]])
      matrix_two = Mathex.Matrix.new!([[0, 0, 1], [1, 0, 0]])

      assert :ok = validate_equal_dimensions(matrix_one, matrix_two)
    end

    test "returns error if matrices have different dimensions" do
      matrix_one = Mathex.Matrix.new!([[1, 2, 3], [1, 2, 3]])
      matrix_two = Mathex.Matrix.new!([[0], [1]])

      assert {:error, reason} = validate_equal_dimensions(matrix_one, matrix_two)
      assert reason == "Matrices should have the same dimension"
    end
  end
end
