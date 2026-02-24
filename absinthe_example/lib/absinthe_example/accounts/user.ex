defmodule AbsintheExample.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:token, :string)

    has_many(:notes, AbsintheExample.Content.Note)
    has_many(:comments, AbsintheExample.Content.Comment)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :token])
    |> validate_required([:name, :email, :token])
    |> unique_constraint(:email)
    |> unique_constraint(:token)
  end
end
