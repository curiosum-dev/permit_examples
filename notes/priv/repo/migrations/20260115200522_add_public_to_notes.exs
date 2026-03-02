defmodule Notes.Repo.Migrations.AddPublicToNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :public, :boolean, default: false, null: false
    end
  end
end
