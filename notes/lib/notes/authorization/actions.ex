defmodule Notes.Authorization.Actions do
  @moduledoc false
  use Permit.Phoenix.Actions, router: NotesWeb.Router
end
