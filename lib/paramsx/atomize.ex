defmodule Paramsx.Atomize do
  def transform(%{} = map),
    do: Enum.into(map, %{}, fn {k, v} -> {String.to_existing_atom(k), transform(v)} end)

  def transform([head | rest]), do: [transform(head) | transform(rest)]
  def transform(not_a_map), do: not_a_map
end
