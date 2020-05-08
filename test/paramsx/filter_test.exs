defmodule Paramsx.FilterTest do
  use ExUnit.Case

  alias Paramsx.Filter

  describe "validate_for_presence/2" do
    params = [a: [:b, [c: [:d]]]]

    filters = [required: [a: :c], optional: []]

    assert Filter.validate_for_presence(params, filters) == :a
  end
end
