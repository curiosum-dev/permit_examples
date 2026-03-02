defmodule Notes.Content.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :title, :string
    field :text, :string

    belongs_to :user, Notes.Accounts.User
    belongs_to :note, Notes.Content.Note

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs, scope) do
    comment
    |> cast(attrs, [:title, :text, :note_id])
    |> validate_required([:title, :text, :note_id])
    |> put_change(:user_id, scope.user.id)
    |> foreign_key_constraint(:note_id)
    |> foreign_key_constraint(:user_id)
  end
end
