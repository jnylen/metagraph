defmodule Database do
  import Comeonin.Bcrypt
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  Documentation for Database.
  """

  ####### User
  def get_user(user_id) when is_binary(user_id) do
    Database.Repo.get(Database.Account, user_id)
  end

  def get_user(_), do: nil

  def get_user!(user_id) when is_binary(user_id) do
    Database.Repo.get!(Database.Account, user_id)
  end

  def get_user!(_), do: nil

  def get_user_by_username(username) do
    Database.Repo.get_by(Database.Account, username: username)
  end

  def get_user_by_email(email) do
    Database.Repo.get_by(Database.Account, email: email)
  end

  def get_user_by_email!(email) do
    Database.Repo.get_by!(Database.Account, email: email)
  end

  def get_user_by_username_and_password(nil, _password), do: {:error, :invalid}
  def get_user_by_username_and_password(_username, nil), do: {:error, :invalid}

  def get_user_by_username_and_password(username, password) do
    with %Database.Account{} = user <-
           Database.Repo.get_by(Database.Account, username: String.downcase(username)),
         true <- Bcrypt.verify_pass(password, user.hashed_password) do
      {:ok, user}
    else
      _ ->
        # Help to mitigate timing attacks
        Bcrypt.no_user_verify()
        {:error, :unauthorised}
    end
  end

  def create_user(params) do
    %Database.Account{}
    |> Database.Account.changeset(params)
    |> Database.Repo.insert()
  end

  ####### Locks
  def get_locks_for_item(uid) do
    from(l in Database.Media.Lock, where: l.subject == ^uid)
    |> Database.Repo.all()
  end
end
