defmodule Notes.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Notes.Content` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        content: "some content",
        name: "some name"
      })

    {:ok, note} = Notes.Content.create_note(scope, attrs)
    note
  end
end
