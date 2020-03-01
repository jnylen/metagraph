defmodule Authorization do
  alias Ueberauth.Auth

  @moduledoc """
  Documentation for Authorization.
  """

  @doc """
  Finds a user

  """
  def authenticate(%Auth{provider: :identity} = auth) do
    Database.get_user_by_username_and_password(auth.uid, auth.credentials.other.password)
  end

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
              password: raw_info["password"]
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
end
