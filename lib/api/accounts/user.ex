defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :encrypted_password, :string
    field :email, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @required_fields [:email, :password]

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email, message: "Email already exists")
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        current_changeset
        |> put_change(:encrypted_password, Bcrypt.hash_pwd_salt(password))
      _ ->
        current_changeset
    end
  end
end
