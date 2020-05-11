# Paramsx

![CI](https://github.com/BCecatto/Paramsx/workflows/CI/badge.svg?branch=master)

A lib to filter params

## Objective

We dont need wait for ecto raise a error in changeset to see a missing key in params

## Installation

```elixir
def deps do
  [
    {:paramsx, "~> 0.1.2"}
  ]
end
```
## Usage
### Atomize your maps

Example:
```elixir
iex> Paramsx.atomize_keys(%{"foo" => "bar"}
%{foo: "bar"}
```

### Filter with required and optional params

Example:
```elixir
iex> Paramsx.filter(%{"foo" => "bar", "other" => "value"}, [required: [:foo], optional: []])
%{"foo" => "bar"}
```

## Incoming improvements:
  - [ ] Scroll through inside nested keywork list to be a better filter;
  - [ ] Config to use Schema of your application to filter;

## License
[Apache License, Version 2.0](LICENSE) 
