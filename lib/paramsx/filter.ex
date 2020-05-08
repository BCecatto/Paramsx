defmodule Paramsx.Filter do
  def validate_for_presence(params, filters) do
    Enum.reduce(params, [], fn {k, v}, acc ->
      key = check_key(k, filters)

      acc ++ [{key, v}]
    end)
    |> Enum.reject(fn {k, _v} -> k == nil end)
    |> Map.new()
  end

  defp check_key(key, filters) when is_binary(key),
    do: if(String.to_atom(key) in filters, do: key)
end
