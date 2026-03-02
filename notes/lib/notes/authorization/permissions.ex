defmodule Notes.Authorization.Permissions do
  @moduledoc false
  use Permit.Ecto.Permissions, actions_module: Notes.Authorization.Actions

  def can(user) do
    permit()
    |> all(Notes.Content.Note, user_id: user.id)
    |> read(Notes.Content.Note, public: true)
    |> create(Notes.Content.Comment, note: [user_id: user.id])
    |> create(Notes.Content.Comment, note: [public: true])
    |> update(Notes.Content.Comment, user_id: user.id)
    |> delete(Notes.Content.Comment, note: [user_id: user.id])
  end
end
