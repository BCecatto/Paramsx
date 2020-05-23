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
## Usage
### Filter with required and optional params

Example:
```elixir
iex> Paramsx.filter(%{"foo" => "bar", "other" => "value"}, [required: [:foo], optional: []])
%{"foo" => "bar"}
```

## Incoming improvements:
  - [x] Scroll through inside nested keyword list to be a better filter;
  - [ ] Config to use Schema of your application to filter;

## License
[Apache License, Version 2.0](LICENSE) 
