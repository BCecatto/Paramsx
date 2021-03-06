# Paramsx

![CI](https://github.com/BCecatto/Paramsx/workflows/CI/badge.svg?branch=master)

Paramsx provides functionally to whitelist and validate parameters

## Objective

We dont need wait for ecto raise a error in changeset to see a missing key in params

## Installation

```elixir
def deps do
  [
    {:paramsx, "~> 0.4.5"}
  ]
end
```

## Add to your Action fallback
You can add this code in your action fallback, it's just a suggestion to do this:
```elixir
  def call(conn, {:error, %{missing_keys: missing_keys}}) do
    conn
    |> Conn.put_resp_content_type("application/json")
    |> Conn.send_resp(
        :bad_request,
        render_error(%{keys: format_missing_keys(missing_keys)})                    
    )
  end

  defp render_error(missing_keys),
    do: Jason.encode!(%{message: "Request body is invalid", errors: missing_keys})

  defp format_missing_keys(keys), do: Enum.reduce(keys, %{}, &format_key/2)

  defp format_key([{key, keys}], map),
    do: Map.put(map, key, format_missing_keys(keys))

  defp format_key({key, keys}, map) when is_list(keys),
    do: Map.put(map, key, format_missing_keys(keys))

  defp format_key(key, map), do: Map.put(map, key, "is required")                                                                 
```
## Usage
### Filter with required and optional params

Example:
```elixir
iex> Paramsx.filter(%{"foo" => "bar", "other" => "value"}, [required: [:foo], optional: []])
{:ok, %{"foo" => "bar"}}

# You have to explicit say that is list when have it, in the fallowing format `key_name_list`
iex> Paramsx.filter(%{"foo" => [%{"bar" => "value_bar"}]}, required: [foo_list: [:bar]])
{:ok, %{foo: [%{bar: "value_bar"}]}}

# If some error appear was triggered the return will be:
iex> Paramsx.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo3])
{:error, %{missing_keys: [:foo3]}} 
```

[Apache License, Version 2.0](LICENSE) 
