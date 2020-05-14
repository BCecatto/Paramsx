defmodule ParamsxTest do
  use ExUnit.Case
  doctest Paramsx

  describe "filter/2" do
    test "given a option required return correct params filtered" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:a, :b]]

      assert Paramsx.filter(params, filters) ==
               {:ok,
                %{
                  "a" => "value_a",
                  "b" => "value_b"
                }}
    end

    test "missing required params return tuple with error" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:c]]

      assert {:error, %{missing_keys: [:c]}} = Paramsx.filter(params, filters)
    end

    test "optional params missing dont trigger tuple error" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:a], optional: [:c]]

      assert Paramsx.filter(params, filters) == {:ok, %{"a" => "value_a"}}
    end

    test "given nested params dont mess up with it" do
      params = %{"a" => %{"c" => "value_c"}, "b" => "value_b"}

      filters = [required: [:a]]

      assert Paramsx.filter(params, filters) == {:ok, %{"a" => %{"c" => "value_c"}}}
    end

    test "when filters is missing return empty map" do
      params = %{"a" => "value_a", "b" => "value_b"}

      assert Paramsx.filter(params, []) == {:ok, %{}}
    end

    test "given optional and required filter work oks" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [optional: [:a], required: [:b]]

      assert Paramsx.filter(params, filters) ==
               {:ok,
                %{
                  "a" => "value_a",
                  "b" => "value_b"
                }}
    end
  end
end
