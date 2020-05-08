defmodule Paramsx.FilterTest do
  use ExUnit.Case

  alias Paramsx.Filter

  describe "validate_for_presence/2" do
    test "given a filter return params filtered" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [:a]

      assert Filter.validate_for_presence(params, filters) == %{"a" => "value_a"}
    end

    test "given nested params dont mess up with it" do
      params = %{"a" => %{"c" => "value_c"}, "b" => "value_b"}

      filters = [:a]

      assert Filter.validate_for_presence(params, filters) == %{"a" => %{"c" => "value_c"}}
    end

    test "when filters is missing return empty map" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [:c]

      assert Filter.validate_for_presence(params, filters) == %{}
    end
  end
end
