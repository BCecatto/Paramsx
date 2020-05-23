# Paramsx

![CI](https://github.com/BCecatto/Paramsx/workflows/CI/badge.svg?branch=master)

Paramsx provides functionally to whitelist and validate parameters

## Objective

We dont need wait for ecto raise a error in changeset to see a missing key in params

## Installation

```elixir
def deps do
  [
    {:paramsx, "~> 0.3.0"}
  ]
end
```

## Handlers
We have a handler to return a json for your, in your module responsible for the action_fallback from phoenix
you can do:

```elixir
defmodule YourModuleOfFalback do
  use Paramsx.ErrorHandlerFallback
  .
  .
  .
end
```
## Usage
### Filter with required and optional params

Example:
```elixir
iex> Paramsx.filter(%{"foo" => "bar", "other" => "value"}, [required: [:foo], optional: []])
{:ok, %{"foo" => "bar"}}

# You have to explicit say that is list when have it:
iex> Paramsx.filter(%{"foo" => [%{"bar" => "value_bar"}]}, required: [foo_list: [:bar]])
{:ok, %{foo: [%{bar: "value_bar"}]}}

# If some error appear was triggered the return will be:
iex> Paramsx.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo3])
{:error, %{missing_keys: [:foo3]}}


 
```

## Incoming improvements:
  - [x] Scroll through inside nested keyword list to be a better filter;
  - [ ] Add more types to verify
  - [ ] Config to use Schema of your application to filter;

## License
[Apache License, Version 2.0](LICENSE) 
