defmodule Database.Repo.Migrations.CreateLocks do
  use Ecto.Migration

  def change do
    create table(:locks, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:subject, :string)
      add(:predicate, :string)

      timestamps()
    end

    create(index(:locks, [:subject]))
  end
end
