defmodule Paramsx do
  @moduledoc """
    Paramsx provides functionally to whitelist and validate parameters
  """

  @doc """
  Filter params based on your required and optional keyword. 

  ## Examples
      iex> Paramsx.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo])
      {:ok, %{foo: "bar"}}
    
      iex> Paramsx.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo3])
      {:error, %{missing_keys: [:foo3]}}

      iex> Paramsx.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo], optional: [:foo3])
      {:ok, %{foo: "bar"}}

  ### Dont allow params list if it's not specified authorize only string and number
     iex> Paramsx.filter(%{"foo" => %{"bar" => "value_bar"}}, required: [:foo])
     {:ok, %{}}

     iex> Paramsx.filter(%{"foo" => %{"bar" => "value_bar"}}, required: [foo: [:bar]])
     {:ok, %{foo: %{bar: "value_bar"}}}
  """

  def filter(params, filters) when is_map(params) and is_list(filters) do
    required = Keyword.get(filters, :required, [])
    optional = Keyword.get(filters, :optional, [])

    params
    |> filter_required(required)
    |> filter_optional(params, optional)
  end

  defp filter_required(params, filters),
    do: reduce_filters(filters, %{}, params, :required)

  defp filter_optional(%{} = acc, params, filters),
    do: {:ok, reduce_filters(filters, acc, params, :optional)}

  defp filter_optional(missing, _params, _filters), do: {:error, %{missing_keys: missing}}

  defp reduce_filters(filters, acc, params, mode),
    do: Enum.reduce(filters, acc, &reduce_fun(&1, &2, params, mode))

  defp reduce_fun([{key, filters}], acc, params, mode) when is_list(filters),
    do: reduce_fun_for_nested(key, filters, acc, params, mode)

  defp reduce_fun({key, filters}, acc, params, mode) when is_list(filters),
    do: reduce_fun_for_nested(key, filters, acc, params, mode)

  defp reduce_fun(key, %{} = acc, params, mode) do
    case fetch(params, key) do
      {:ok, value} when is_binary(value) or is_number(value) -> Map.put(acc, key, value)
      {:ok, _value} -> acc
      _not_found -> handle_missing_key(mode, acc, key)
    end
  end

  defp reduce_fun(key, missing, params, _mode) when is_list(missing) do
    if Map.has_key?(params, to_string(key)) do
      missing
    else
      [key | missing]
    end
  end

  defp reduce_fun_for_nested(key, filters, acc, params, mode) do
    case fetch(params, key) do
      {:ok, value} -> handle_partial(mode, reduce_filters(filters, %{}, value, mode), key, acc)
      _not_found -> handle_partial(mode, filters, key, acc)
    end
  end

  defp handle_partial(_mode, value, key, acc) when is_map(acc) and is_map(value),
    do: Map.put(acc, key, value)

  defp handle_partial(:required, missing, key, %{}) when is_list(missing), do: [{key, missing}]

  defp handle_partial(:required, missing, key, acc)
       when is_list(missing) and is_list(acc) and is_atom(key),
       do: [[{key, missing}] | acc]

  defp handle_partial(:optional, missing, _k, acc) when is_list(missing) and is_list(acc), do: acc
  defp handle_missing_key(:required, _acc, key), do: [key]
  defp handle_missing_key(:optional, acc, _key), do: acc
  defp fetch(map, key) when is_atom(key), do: Map.fetch(map, Atom.to_string(key))
end
