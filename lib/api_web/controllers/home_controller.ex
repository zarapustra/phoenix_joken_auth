defmodule ApiWeb.HomeController do
  use ApiWeb, :controller

  def index(conn, %{}) do
    conn
    |> put_status(200)
    |> json(%{data: %{message: "Hello World!"}})
  end
end
