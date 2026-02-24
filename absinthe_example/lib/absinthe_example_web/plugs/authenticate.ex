defmodule AbsintheExampleWeb.Plugs.Authenticate do
  @behaviour Plug

  import Plug.Conn

  alias AbsintheExample.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case Accounts.get_user_by_token(token) do
          nil ->
            conn

          user ->
            Absinthe.Plug.put_options(conn, context: %{current_user: user})
        end

      _ ->
        conn
    end
  end
end
