defmodule ApiWeb.ApiAuthPlug do
  @moduledoc false
  alias Api.Token
  @signer Joken.Signer.create("HS256", "secret")

  @doc false
  def init(options) do
    options
  end

  @doc false
  def call(conn, _opts) do
    conn
    |> current_user
    |> maybe_fetch_user(conn)
  end

  ### Authenticate with token 

  defp current_user(conn) do
    Map.get(conn, :current_user)
  end

  defp maybe_fetch_user(nil, conn), do: do_fetch(conn)
  defp maybe_fetch_user(_user, conn), do: conn
  
  defp do_fetch(conn) do
    conn
    |> fetch_user_by_token
    |> assign_user(conn)
  end

  def fetch_user_by_token(conn) do
    conn
    |> fetch_auth_token
    |> Token.verify_and_validate(@signer)
    |> get_user
  end

  def get_user({:error, _}), do: :not_found
  def get_user({:ok, claims}) do
    user_id = claims["user_id"]
    Api.Accounts.get_user!(user_id)
  end

  
  defp fetch_auth_token(conn) do
    conn
    |> Plug.Conn.get_req_header("authorization")
    |> List.first()
  end

  defp assign_user(:not_found, conn), do: conn
  defp assign_user(user, conn), do: Map.put(conn, :current_user, user)

  ### Get token with email and password

  def authenticate_user(conn, user_params) do
    %{"email" => email , "password" => password} = user_params
    Api.Accounts.get_by_email(email) |> check_pass_and_login(password, conn)
  end

  def check_pass_and_login(nil, _password, conn), do: {:error, conn}
  def check_pass_and_login(user, password, conn) do
    %{encrypted_password: hash} = user
  
    Bcrypt.verify_pass(password, hash)
    |> case do
      false -> {:error, conn}
      true -> { :ok, create_token(conn, user)}
    end
  end
  def create_token(conn, user) do
    extra_claims = %{"user_id" => user.id}
    
    token = Token.generate_and_sign!(extra_claims, @signer)
    conn = Map.put(conn, :current_user, user)
    {conn, token}
  end
end

