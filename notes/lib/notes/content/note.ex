defmodule Notes.Content.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :name, :string
    field :content, :string
    field :public, :boolean, default: false

    belongs_to :user, Notes.Accounts.User
    has_many :comments, Notes.Content.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(note, attrs, user_scope) do
    note
    |> cast(attrs, [:name, :content, :public])
    |> validate_required([:name, :content])
    |> put_change(:user_id, user_scope.user.id)
  end
end
