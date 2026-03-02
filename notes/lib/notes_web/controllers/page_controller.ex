defmodule NotesWeb.PageController do
  use NotesWeb, :controller

  def home(conn, _params) do
    case conn.assigns[:current_scope] do
      %{user: _user} ->
        redirect(conn, to: ~p"/notes")

      _ ->
        render(conn, :home)
    end
  end
end
