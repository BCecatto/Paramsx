defmodule Paramsx do
  alias Paramsx.{Atomize, Filter}

  @moduledoc """
    Documentation for Paramsx.
  """

  @doc """
  Filter params based in your  required and optional keyword.

  ## Examples
    
      iex> Params.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo])
      %{"foo" => "bar", "foo2" => "bar2"}
    
      iex> Params.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo3])
      {:error, %{missing_keys: [:foo3]}}

      iex> Params.filter(%{"foo" => "bar", "foo2" => "bar2"}, required: [:foo], optional: [:foo3])
      %{"foo" => "bar"}  
  """

  def filter(params, filters), do: Filter.validate_for_presence(params, filters)

  @doc """
  Atomize keys values.

  ## Examples
    
      iex> Params.atomize_keys(%{"foo" => "bar"})
      %{foo: "bar"}
  """

  def atomize_keys(params), do: Atomize.transform(params)
end
