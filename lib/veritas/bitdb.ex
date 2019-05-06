defmodule Veritas.Bitdb do
  use Tesla
  @api_key "1DkBxWipgByk5ZCoQ6KVKvTZTY11DmSB5x"

  plug Tesla.Middleware.BaseUrl, "https://genesis.bitdb.network/q/1FnauZ9aUH2Bex6JzdcV4eNX7oLSSEbxtN"
  plug Tesla.Middleware.Headers, [{:key, @api_key}]
  plug Tesla.Middleware.JSON

  def query(q) do
    case get(q) |> IO.inspect() do
      {:ok, resp} ->
        case Map.get(resp.body, "u") do
          [] ->
            {:ok, Map.get(resp.body, "c")}
          _ ->
            {:ok, Map.get(resp.body, "u")}
        end

      {:error, msg} ->
        {:error, msg}
    end
  end
end
