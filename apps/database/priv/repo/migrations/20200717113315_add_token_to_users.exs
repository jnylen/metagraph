defmodule Database.Repo.Migrations.AddTokenToUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS \"pgcrypto\""

    alter table(:accounts) do
      add(:token, :uuid, null: false, default: fragment("gen_random_uuid()"))
    end

    create(index(:accounts, [:token], unique: true))
  end
end
