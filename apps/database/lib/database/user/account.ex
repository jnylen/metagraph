defmodule Database.Account do
  @moduledoc """
  An account
  """

  use Database.Schema

  schema "accounts" do
    field(:name, :string)
    field(:username, :string)
    field(:hashed_password, :string)
    field(:email, :string)
    field(:text, :string)
    field(:token, :binary_id)

    # Add a virtual attribute to hold plain text passwords.
    field(:password, :string, virtual: true)

    timestamps()
  end

  def changeset(channel, params \\ %{}) do
    channel
    |> cast(params, [
      :name,
      :username,
      :password,
      :email,
      :text
    ])
    |> validate_required([:username, :password, :email])
    |> unique_constraint(:username)

    # Hash passwords before saving them to the database.
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end
