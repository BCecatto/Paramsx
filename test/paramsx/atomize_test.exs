defmodule Paramsx.AtomizeTest do
  use ExUnit.Case

  alias Paramsx.Atomize

  describe "transform/1" do
    test "given a map with a string key transform to atom" do
      string_map = %{"key" => "value", "key2" => "value2"}

      expected_map = %{key: "value", key2: "value2"}

      assert Atomize.transform(string_map) == expected_map
    end

    test "transform nested map string key to atom" do
      string_map_nested = %{"foo" => [%{"key" => "value"}]}

      expected_map = %{foo: [%{key: "value"}]}
      assert Atomize.transform(string_map_nested) == expected_map
    end
  end
end
