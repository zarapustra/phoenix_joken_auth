defmodule ApiWeb.ApiAuthErrorHandler do
  use ApiWeb, :controller
  alias Plug.Conn

  def call(conn, :not_authenticated) do
    conn
    |> put_status(401)
    |> json(%{error: %{code: 401, message: "Not authenticated"}})
  end
end