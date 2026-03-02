defmodule Notes.Authorization do
  @moduledoc false
  use Permit.Ecto, permissions_module: Notes.Authorization.Permissions, repo: Notes.Repo
end
