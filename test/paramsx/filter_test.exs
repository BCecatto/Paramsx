defmodule Paramsx.FilterTest do
  use ExUnit.Case

  alias Paramsx.Filter

  describe "validate_for_presence/2" do
    test "given a option required return correct params filtered" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:a, :b]]

      assert Filter.validate_for_presence(params, filters) == %{
               "a" => "value_a",
               "b" => "value_b"
             }
    end

    test "missing required params return tuple with error" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:c]]

      assert {:error, %{missing_keys: [:c]}} = Filter.validate_for_presence(params, filters)
    end

    test "optional params missing dont trigger tuple error" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:a], optional: [:c]]

      assert Filter.validate_for_presence(params, filters) == %{"a" => "value_a"}
    end

    test "given nested params dont mess up with it" do
      params = %{"a" => %{"c" => "value_c"}, "b" => "value_b"}

      filters = [required: [:a]]

      assert Filter.validate_for_presence(params, filters) == %{"a" => %{"c" => "value_c"}}
    end

    test "when filters is missing return empty map" do
      params = %{"a" => "value_a", "b" => "value_b"}

      assert Filter.validate_for_presence(params, []) == %{}
    end

    test "given optional and required filter work oks" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [optional: [:a], required: [:b]]

      assert Filter.validate_for_presence(params, filters) == %{
               "a" => "value_a",
               "b" => "value_b"
             }
    end
  end
end
