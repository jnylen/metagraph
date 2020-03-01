defmodule Database.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:username, :string)
      add(:hashed_password, :string)
      add(:email, :string)
      add(:text, :text)

      timestamps()
    end

    create(index(:accounts, [:email], unique: true))
    create(index(:accounts, [:username], unique: true))
  end
end
