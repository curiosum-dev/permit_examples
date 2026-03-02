defmodule Notes.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Notes.Content.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(scope, note, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "some title",
        text: "some text",
        note_id: note.id
      })

    {:ok, comment} = Notes.Content.Comments.create_comment(scope, attrs)
    comment
  end
end
