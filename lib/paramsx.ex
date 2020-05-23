defmodule Paramsx do
  @moduledoc """
    Paramsx provides functionally to whitelist and validate parameters
  """

  @doc """
  Filter params based on your required and optional keyword. 

  Important: You have to allow all params correctly, by default it allow only string or number
  for a simple key, if you want specify a keyword list with correct params like the last example.

  ## Examples
      iex> Paramsx.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo])
      {:ok, %{foo: "bar"}}
    
      iex> Paramsx.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo3])
      {:error, %{missing_keys: [:foo3]}}

      iex> Paramsx.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo], optional: [:foo3])
      {:ok, %{foo: "bar"}}

      iex> Paramsx.filter(%{"foo" => %{"bar" => "value_bar"}}, required: [:foo])
      {:error, %{missing_keys: [:foo]}}

      iex> Paramsx.filter(%{"foo" => %{"bar" => "value_bar"}}, required: [foo: [:bar]])
      {:ok, %{foo: %{bar: "value_bar"}}}

      iex> Paramsx.filter(%{"foo" => [%{"bar" => "value_bar"}]}, required: [foo_list: [:bar]])
      {:ok, %{foo: [%{bar: "value_bar"}]}}
  """

  def filter(params, filters) when params == %{},
    do: {:error, %{missing_keys: Keyword.get(filters, :required, [])}}

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

  defp reduce_fun([{key, filters}], acc, params, mode) when is_list(filters) do
    {:ok, %{key: key}} =
      key
      |> split_word_by_dash()
      |> key_type()

    reduce_fun_for_nested(key, filters, acc, params, mode)
  end

  defp reduce_fun({key, filters}, acc, params, mode) when is_list(filters) do
    key
    |> split_word_by_dash()
    |> key_type()
    |> verify_list_of_atoms(filters)
    |> call_for(filters, acc, params, mode)
  end

  defp reduce_fun(_key, %{} = acc, [], _mode), do: acc

  defp reduce_fun(key, %{} = acc, %{} = params, mode) do
    case fetch(params, key) do
      {:ok, value} when is_binary(value) or is_number(value) -> Map.put(acc, key, value)
      {:ok, _value} -> handle_missing_key(mode, acc, key)
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

  defp handle_partial(_mode, value, _key, result) when is_list(result) and is_map(value),
    do: result

  defp handle_partial(_mode, value, key, acc) when is_map(acc) and is_map(value),
    do: Map.put(acc, key, value)

  defp handle_partial(:required, missing, key, %{}) when is_list(missing), do: [{key, missing}]

  defp handle_partial(:required, missing, key, acc)
       when is_list(missing) and is_list(acc) and is_atom(key),
       do: [[{key, missing}] | acc]

  defp handle_partial(:optional, missing, _k, acc) when is_list(missing) and is_list(acc), do: acc

  defp generate_list_of_params(_keys, acc, _params, _key, _mode) when is_list(acc), do: acc

  defp generate_list_of_params(keys, %{} = acc, params, key, mode) do
    case fetch(params, key) do
      {:ok, nested_params} ->
        nested_params
        |> Enum.reduce([], &create_nested_map(&1, &2, keys, mode))
        |> update_acc_with_generated_list(acc, key, mode)

      _not_found ->
        handle_missing_key(mode, acc, key)
    end
  end

  defp create_nested_map(params, list_acc, keys, _mode) do
    case create_params_map(keys, params) do
      %{} = acc -> Enum.concat([acc], list_acc)
      keys_not_found -> keys_not_found
    end
  end

  defp create_params_map(keys, params) do
    Enum.reduce(keys, %{}, fn key, map_acc ->
      case fetch(params, key) do
        {:ok, value} -> set_new_value(map_acc, key, value)
        _not_found -> set_new_value(map_acc, key, [key])
      end
    end)
  end

  defp set_new_value(acc, key, value) when is_list(acc) and is_list(value),
    do: [key | acc]

  defp set_new_value(_acc, _key, value) when is_list(value), do: value
  defp set_new_value(acc, key, value) when is_map(acc), do: Map.put(acc, key, value)

  defp update_acc_with_generated_list(generated_list, acc, key, mode) do
    case list_of_atoms?(generated_list) do
      true -> handle_missing_key(mode, acc, {key, generated_list})
      false -> Map.put(acc, key, generated_list)
    end
  end

  defp handle_missing_key(:required, _acc, key), do: [key]
  defp handle_missing_key(:optional, acc, _key), do: acc

  defp call_for({:ok, key}, filters, acc, params, mode),
    do: generate_list_of_params(filters, acc, params, key, mode)

  defp call_for({:error, key}, filters, acc, params, mode),
    do: reduce_fun_for_nested(key, filters, acc, params, mode)

  defp split_word_by_dash(key), do: key |> to_string() |> String.split("_")
  defp key_type([key]), do: {:ok, %{key: String.to_atom(key), type: "default"}}
  defp key_type([key, type]), do: {:ok, %{key: String.to_atom(key), type: type}}

  defp verify_list_of_atoms({:ok, %{type: "default", key: [key]}}, _list),
    do: {:error, key}

  defp verify_list_of_atoms({:ok, %{type: "default", key: key}}, _list),
    do: {:error, key}

  defp verify_list_of_atoms({:ok, %{type: "list", key: key}}, list) do
    if list_of_atoms?(list) do
      {:ok, key}
    else
      {:error, key}
    end
  end

  defp list_of_atoms?(list), do: Enum.all?(list, &is_atom/1)

  defp fetch(map, key) when is_atom(key) and is_map(map), do: Map.fetch(map, to_string(key))
end
