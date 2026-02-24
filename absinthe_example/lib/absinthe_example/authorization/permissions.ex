defmodule AbsintheExample.Authorization.Permissions do
  use Permit.Ecto.Permissions, actions_module: AbsintheExample.Authorization.Actions

  alias AbsintheExample.Accounts.User
  alias AbsintheExample.Content.{Note, Comment}
  require Ecto.Query

  @doc """
  Define permissions for authenticated users.

  Rules:
  - Notes: Can read own notes or public notes. Can create, update, delete only own notes.
  - Comments: Can read/create if note is public. Can update own comments. Can delete own comments or comments on own notes.
  """
  def can(%User{id: user_id} = _user) do
    permit()
    # Notes: read own notes
    |> read(Note, user_id: user_id)
    # Notes: read public notes
    |> read(Note, public: true)
    # Notes: create notes (user_id will be set to current user)
    |> create(Note)
    # Notes: update/delete only own notes
    |> update(Note, user_id: user_id)
    |> delete(Note, user_id: user_id)
    # Comments: read if note is public
    |> read(Comment, note: [public: true])
    # Comments: create if note is public (checked in resolver)
    |> create(Comment)
    # Comments: update only own comments
    |> update(Comment, user_id: user_id)
    # Comments: delete own comments
    |> delete(Comment, user_id: user_id)
    # Comments: delete comments on own notes
    |> delete(Comment, note: [user_id: user_id])
  end

  def can(_user) do
    # No permissions for unauthenticated users
    permit()
  end
end
