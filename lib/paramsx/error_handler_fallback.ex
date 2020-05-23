defmodule Paramsx.ErrorHandlerFallback do
  defmacro __using__(_opts \\ []) do
    alias Plug.Conn

    quote do
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
    end
  end
end
