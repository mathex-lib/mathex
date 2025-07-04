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
      assert {:error, _} = validate_is_list_of_lists([1, 2, 3, 4])
    end

    test "returns error for non-list input" do
      assert {:error, _} = validate_is_list_of_lists(:not_a_list)
    end

    test "returns error if one row is not a list" do
      assert {:error, _} = validate_is_list_of_lists([[1, 2], 42])
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
      assert {:error, _} = validate_non_empty([])
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
      assert {:error, _} = validate_uniform_columns([[1], [2, 3]])
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
      assert {:error, _} = validate_non_empty_columns([[]])
    end

    test "returns error for at least one empty list" do
      assert {:error, _} = validate_non_empty_columns([[1, 2], [], [4, 5]])
    end
  end
end
