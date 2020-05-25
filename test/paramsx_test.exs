defmodule ParamsxTest do
  use ExUnit.Case
  doctest Paramsx

  describe "filter/2" do
    test "given a empty params" do
      params = %{}

      required = [
        :name,
        [authentication: [:role, logins_list: [:email, :phone], foo_list: [:bar]]]
      ]

      optional = [:description, address: [:street]]

      filters = [required: required, optional: optional]

      assert Paramsx.filter(params, filters) ==
               {:error, %{missing_keys: required}}
    end

    test "given a option required return correct params filtered" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:a, :b]]

      assert Paramsx.filter(params, filters) ==
               {:ok,
                %{
                  a: "value_a",
                  b: "value_b"
                }}
    end

    test "missing required params return tuple with error" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:b, c: [:d]]]

      assert {:error, %{missing_keys: [c: [:d]]}} = Paramsx.filter(params, filters)
    end

    test "optional params missing dont trigger tuple error" do
      params = %{"a" => "value_a", "b" => "value_b"}

      filters = [required: [:a], optional: [:c]]

      assert Paramsx.filter(params, filters) == {:ok, %{a: "value_a"}}
    end

    test "given nested params dont mess up with it" do
      params = %{"a" => %{"c" => "value_c"}, "b" => "value_b"}

      filters = [required: [a: [:c]]]

      assert Paramsx.filter(params, filters) == {:ok, %{a: %{c: "value_c"}}}
    end

    test "when filters is missing return empty map" do
      params = %{"a" => "value_a", "b" => "value_b"}

      assert Paramsx.filter(params, []) == {:ok, %{}}
    end

    test "nested list return correctly" do
      params = %{
        "name" => "some name",
        "phone" => "1199999999",
        "description" => "some description",
        "address" => %{
          "street" => "street 5",
          "type" => "some type"
        },
        "authentication" => %{
          "role" => 5,
          "admin" => "some private rule",
          "logins" => [
            %{"email" => "daniel@mail.com", "phone" => "9999", "admin" => true},
            %{"email" => "other@email", "phone" => "12312", "admin" => false},
            %{"email" => "bruno@email", "phone" => "12_312_312", "admin" => true}
          ],
          "foo" => [%{"bar" => "bar_name"}]
        }
      }

      required = [
        :name,
        [authentication: [:role, logins_list: [:email, :phone], foo_list: [:bar]]]
      ]

      optional = [:description, address: [:street]]

      expected =
        {:ok,
         %{
           name: "some name",
           description: "some description",
           address: %{street: "street 5"},
           authentication: %{
             role: 5,
             logins: [
               %{email: "bruno@email", phone: "12_312_312"},
               %{email: "other@email", phone: "12312"},
               %{email: "daniel@mail.com", phone: "9999"}
             ],
             foo: [%{bar: "bar_name"}]
           }
         }}

      assert Paramsx.filter(params, required: required, optional: optional) == expected
    end

    test "nested required list trigger correct error" do
      params = %{
        "name" => "some name",
        "phone" => "1199999999",
        "description" => "some description",
        "address" => %{
          "street" => "street 5",
          "type" => "some type"
        },
        "authentication" => %{
          "role" => 5,
          "admin" => "some private rule"
        }
      }

      required = [
        :name,
        [authentication: [:role, [logins_list: [:email, :phone, :other, :other_missing]]]]
      ]

      optional = [:description, address: [:street]]

      assert Paramsx.filter(params, required: required, optional: optional) ==
               {
                 :error,
                 %{
                   missing_keys: [
                     authentication: [
                       logins: [:email, :phone, :other, :other_missing]
                     ]
                   ]
                 }
               }
    end

    test "nested optional list dont trigger error" do
      params = %{
        "name" => "some name",
        "phone" => "1199999999",
        "description" => "some description",
        "address" => %{
          "street" => "street 5",
          "type" => "some type"
        },
        "authentication" => %{
          "role" => 5,
          "admin" => "some private rule"
        }
      }

      optional = [
        :name,
        [authentication: [:role, [logins_list: [:email, :phone, :other, :other_missing]]]]
      ]

      assert Paramsx.filter(params, optional: optional) ==
               {:ok, %{authentication: %{role: 5}, name: "some name"}}
    end

    test "split correctly a key if type is pass in the format key_name_list" do
      params = %{
        "name" => "some name",
        "phone" => "1199999999",
        "description" => "some description",
        "address" => %{
          "street" => "street 5",
          "type" => "some type"
        },
        "authentication" => %{
          "role" => "some role",
          "admin" => "some private rule",
          "login" => %{
            "email" => "daniel@mail.com"
          }
        }
      }

      required = [:name, :authentication]
      optional = [:description, address: [:street]]

      expected = {:error, %{missing_keys: [:authentication]}}

      assert Paramsx.filter(params, required: required, optional: optional) == expected
    end
  end
end
