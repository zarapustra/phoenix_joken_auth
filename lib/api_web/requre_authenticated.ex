defmodule ApiWeb.RequireAuthenticated do
  @moduledoc """
  This plug ensures that a user has been authenticated.
  """
  alias Plug.Conn
  
  defmodule ConfigError do
    @moduledoc false
    defexception [:message]
  end

  @doc false
  def init(config) do
    case Keyword.get(config, :error_handler, :not_found) do
      :not_found -> raise_no_error_handler()
      value      -> value
    end
  end

  @doc false
  def call(conn, handler) do
    conn
    |> Map.get(:current_user)
    |> maybe_halt(conn, handler)
  end

  defp maybe_halt(nil, conn, handler) do
    conn
    |> handler.call(:not_authenticated)
    |> Conn.halt()
  end
  defp maybe_halt(_user, conn, _handler), do: conn

  defp raise_no_error_handler do
    raise_error("No :error_handler configuration option provided. It's required to set this when using #{inspect __MODULE__}.")
  end

  def raise_error(message) do
    raise ConfigError, message: message
  end
end