defmodule Notes.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :title, :string, null: false
      add :text, :text, null: false
      add :user_id, references(:users, type: :id, on_delete: :delete_all), null: false
      add :note_id, references(:notes, type: :id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:user_id])
    create index(:comments, [:note_id])
  end
end
