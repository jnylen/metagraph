defmodule Database.Repo.Migrations.CreateChanges do
  use Ecto.Migration

  def change do
    create table(:changes, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:action, :string)
      add(:subject, :string)
      add(:original, :map)
      add(:changes, :map)
      add(:actor, references("accounts", on_delete: :nilify_all, type: :uuid))

      timestamps()
    end

    create(index(:changes, [:actor]))
    create(index(:changes, [:subject]))
  end
end
