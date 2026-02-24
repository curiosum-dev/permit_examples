defmodule AbsintheExample.Content.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field(:title, :string)
    field(:content, :string)
    field(:public, :boolean, default: false)

    belongs_to(:user, AbsintheExample.Accounts.User)
    has_many(:comments, AbsintheExample.Content.Comment)

    timestamps()
  end

  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :content, :public, :user_id])
    |> validate_required([:title, :content, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
