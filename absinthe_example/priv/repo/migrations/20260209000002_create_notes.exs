defmodule AbsintheExample.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :content, :text, null: false
      add :public, :boolean, default: false, null: false

      timestamps()
    end

    create index(:notes, [:user_id])
  end
end
