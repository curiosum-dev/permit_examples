defmodule AbsintheExample.Authorization do
  use Permit.Ecto,
    permissions_module: AbsintheExample.Authorization.Permissions,
    repo: AbsintheExample.Repo
end
