defmodule ApiWeb.RegistrationController do
  use ApiWeb, :controller

  def create(conn, %{"user" => user_params}) do
    Api.Accounts.create_user(user_params)
    |> case do
      {:ok, user} ->
        { conn, token } = ApiWeb.ApiAuthPlug.create_token(conn, user)

        conn
        |> put_status(:created)
        |> json(%{data: %{token: token}})

      {:error, changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, &ApiWeb.ErrorHelpers.translate_error/1)

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: %{message: "Couldn't create user", errors: errors}})
    end
  end
end