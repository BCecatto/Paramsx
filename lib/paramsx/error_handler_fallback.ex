defmodule Paramsx.ErrorHandlerFallback do
  defmacro __using__(_opts \\ []) do
    quote do
      import Plug.Conn, only: [put_status: 2]

      def call(conn, {:error, %{missing_keys: missing_keys}}) do
        conn
        |> put_status(:bad_request)
        |> render_error(%{keys: format_missig_keys(missing_keys)})
      end

      defp render_error(conn, missing_keys),
        do: Map.put(conn, :resp_body, %{message: "Request body is invalid", errors: missing_keys})

      defp format_missig_keys(keys), do: Enum.reduce(keys, %{}, &format_key/2)

      defp format_key([{key, keys}], map),
        do: Map.put(map, key, format_missig_keys(keys))

      defp format_key({key, keys}, map) when is_list(keys),
        do: Map.put(map, key, format_missig_keys(keys))

      defp format_key(key, map), do: Map.put(map, key, "is required")
    end
  end
end
