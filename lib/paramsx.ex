defmodule Paramsx do
  alias Paramsx.Filter

  def filter(params, filters), do: Filter.validate_for_presence(params, filters)

  def atomize_keys(params), do: Atomize.transform(params)
end
