defmodule Paramsx.Filter do
  def validate_for_presence(params, filters) do
    required_fields = Keyword.get(filters, :required, [])
    optional_fields = Keyword.get(filters, :optional, [])

    params
    |> filter_required_fields(required_fields)
  end

  defp filter_required_fields([head | tail], filters) do
  end
end
