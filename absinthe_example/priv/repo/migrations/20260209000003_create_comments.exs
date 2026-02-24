defmodule AbsintheExample.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :note_id, references(:notes, on_delete: :delete_all), null: false
      add :title, :string, null: false
      add :content, :text, null: false

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:note_id])
  end
end
