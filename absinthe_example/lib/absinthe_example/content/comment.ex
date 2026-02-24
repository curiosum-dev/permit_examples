defmodule AbsintheExample.Content.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field(:title, :string)
    field(:content, :string)

    belongs_to(:user, AbsintheExample.Accounts.User)
    belongs_to(:note, AbsintheExample.Content.Note)

    timestamps()
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:title, :content, :user_id, :note_id])
    |> validate_required([:title, :content, :user_id, :note_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:note_id)
  end
end
