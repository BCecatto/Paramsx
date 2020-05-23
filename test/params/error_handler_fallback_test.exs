defmodule Paramsx.ErrorHandlerFallbackTest do
  use ExUnit.Case
  use Paramsx.ErrorHandlerFallback

  describe "call/2" do
    test "when found missing_keys return :bad_request" do
    end
  end
end
