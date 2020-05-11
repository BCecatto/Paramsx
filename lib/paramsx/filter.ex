defmodule Paramsx.Filter do
  def validate_for_presence(params, filters) when is_list(filters) do
    required = Keyword.get(filters, :required, [])
    optional = Keyword.get(filters, :optional, [])

    params
    |> filter_required(required)
    |> filter_optional(params, optional)
    |> handle_response()
  end

  defp filter_required(params, filters) do
    Enum.reduce(filters, %{found_keys: [], missing_keys: []}, fn key, acc ->
      case check_key(key, params, :required) do
        {:ok, key_and_value} ->
          %{found_keys: [key_and_value | acc.found_keys], missing_keys: acc.missing_keys}

        {:error, missing_key: key} ->
          %{found_keys: acc.found_keys, missing_keys: [key | acc.missing_keys]}
      end
    end)
  end

  defp filter_optional(%{missing_keys: []} = start_acc, params, filters) do
    Enum.reduce(filters, start_acc, fn key, acc ->
      case check_key(key, params, :optional) do
        {:ok, key_and_value} ->
          %{found_keys: [key_and_value | acc.found_keys], missing_keys: acc.missing_keys}

        {:error, :param_not_present} ->
          acc
      end
    end)
  end

  defp filter_optional(%{missing_keys: _keys} = filtered, _params, _filters),
    do: filtered

  defp check_key(filter_key, params, :required) do
    case Map.fetch(params, Atom.to_string(filter_key)) do
      {:ok, value} -> {:ok, {Atom.to_string(filter_key), value}}
      :error -> {:error, missing_key: filter_key}
    end
  end

  defp check_key(filter_key, params, :optional) do
    case Map.fetch(params, Atom.to_string(filter_key)) do
      {:ok, value} -> {:ok, {Atom.to_string(filter_key), value}}
      :error -> {:error, :param_not_present}
    end
  end

  defp handle_response(%{missing_keys: [], found_keys: keys}), do: Map.new(keys)

  defp handle_response(%{missing_keys: missing_params}),
    do: {:error, %{missing_keys: missing_params}}
end
