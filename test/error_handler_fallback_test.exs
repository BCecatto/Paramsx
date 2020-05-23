defmodule Paramsx.ErrorHandlerFallbackTest do
  use ExUnit.Case
  import Phoenix.ConnTest, only: [build_conn: 0]

  use Paramsx.ErrorHandlerFallback

  describe "call/2" do
    test "when found missing_keys return :bad_request" do
      conn = build_conn()

      params = {
        :error,
        %{
          missing_keys: [
            :name,
            authentication: [
              logins: [:email, :phone, :other, :other_missing]
            ]
          ]
        }
      }

      expected_response = %{
        errors: %{
          keys: %{
            authentication: %{
              logins: %{
                email: "is required",
                other: "is required",
                other_missing: "is required",
                phone: "is required"
              }
            },
            name: "is required"
          }
        },
        message: "Request body is invalid"
      }

      assert call(conn, params) == expected_response
    end
  end
end
