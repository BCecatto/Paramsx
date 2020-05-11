# Paramsx

A lib to filter params

## Objective

We dont need wait for ecto raise a error in changeset to see a missing key in params

## Installation

```elixir
def deps do
  [
    {:paramsx, "~> 0.1.0"}
  ]
end
```
## Usage
Atomize your maps

Example:
```
Paramsx.atomize_keys(%{"foo" => "bar"} [brainn.co](https://github.com/brainn-co))
-> %{foo: "bar"}
```

Filter with required and optional opt

Example:
```
Paramsx.filter(%{"foo" => "bar", "other" => "value"}, [required: [:foo], optional: []])
-> %{"foo" => "bar"}
```

Incoming improvements:
 - [  ] Scroll through inside nested keywork list to be a better filter

## License
[Apache License, Version 2.0](LICENSE) 
