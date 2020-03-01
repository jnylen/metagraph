defmodule Frontend.User do
  # import Comeonin.Bcrypt
  alias Ueberauth.Auth
  # alias Comeonin.Bcrypt

  @moduledoc """
  This is just a helper library linked to the Database to check if logins match.
  """

  @doc """
  Finds a user

  """
  def authenticate(%Auth{provider: :identity} = auth) do
    Database.get_user_by_email(auth.uid)
    |> authorize(auth)
    |> info_from_database
  end

  defp authorize(nil, _auth), do: {:error, "Invalid username or password"}

  defp authorize(user, auth) do
    Bcrypt.verify_pass(auth.credentials.other.password, user.password)
    |> resolve_authorization(user)
  end

  defp resolve_authorization(false, _user), do: {:error, "Invalid username or password"}
  defp resolve_authorization(true, user), do: {:ok, info_from_database(user)}

  @doc """
  Creates
  """
  def create(%Auth{extra: %{raw_info: raw_info}, provider: :identity} = auth) do
    case Database.get_user_by_email(auth.uid) do
      nil ->
        case validate_pass(raw_info) do
          {:error, error} ->
            {:error, error}

          {:ok, _} ->
            Database.create_user(%{
              username: raw_info["username"],
              email: raw_info["email"],
              password: Bcrypt.hash_pwd_salt(raw_info["password"])
            })
        end

      _user ->
        {:error, "User already exists"}
    end
  end

  @doc """

  """
  def validate_pass(%{"password" => pw, "password_confirmation" => pw} = _auth_params),
    do: {:ok, "both the same"}

  def validate_pass(_), do: {:error, "the passwords must match"}

  defp info_from_database({:error, error}), do: {:error, error}

  defp info_from_database(user) do
    user
  end
end
