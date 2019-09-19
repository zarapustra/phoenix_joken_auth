defmodule ApiWeb.SessionController do
  use ApiWeb, :controller

  def create(conn, %{"user" => user_params}) do
    conn
    |> ApiWeb.ApiAuthPlug.authenticate_user(user_params)
    |> case do
      {:ok, {conn, token}} ->
        json(conn, %{data: %{token: token}})

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end
end
