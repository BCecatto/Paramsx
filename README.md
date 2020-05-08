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
```
Paramsx.atomize_keys(%{"foo" => "bar"})
-> %{foo: "bar"}
```

```
Paramsx.filter(%{"foo" => "bar", "other" => "value"}, [:foo])
-> %{"foo" => "bar"}
```

Incoming improvements:
 - [  ] Pass params like [required: [:a], optional: [:b]] to trigger error before reach ecto.
 - [  ] Scroll through inside nested keywork list to be a better filter

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/paramsx](https://hexdocs.pm/paramsx).

