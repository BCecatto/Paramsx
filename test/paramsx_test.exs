defmodule ParamsxTest do
  use ExUnit.Case

  describe "filter/2" do
    test "filter params with success and atomize keys" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:a, :b]]

      response =
        params
        |> Paramsx.filter(filters)
        |> Paramsx.atomize_keys()

      assert response == %{a: "value_a", b: "value_b"}
    end
  end

  describe "atomize_keys/1" do
    test "atomize keys with success" do
      params = %{"a" => "value_a", "b" => "value_b"}

      assert Paramsx.atomize_keys(params) == %{a: "value_a", b: "value_b"}
    end
  end
end
