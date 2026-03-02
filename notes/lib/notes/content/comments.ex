defmodule Notes.Content.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Notes.Repo

  alias Notes.Content.Comment
  alias Notes.Accounts.Scope

  @doc """
  Returns the list of comments for a given note.

  ## Examples

      iex> list_comments(scope, note_id)
      [%Comment{}, ...]

  """
  def list_comments(%Scope{} = _scope, note_id) do
    Comment
    |> where(note_id: ^note_id)
    |> Repo.all()
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(scope, 123)
      %Comment{}

      iex> get_comment!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(%Scope{} = _scope, id) do
    Repo.get!(Comment, id)
  end

  @doc """
  Creates a comment on a note.

  The user must have read access to the note (enforced by Permit at a higher level).

  ## Examples

      iex> create_comment(scope, %{field: value})
      {:ok, %Comment{}}

      iex> create_comment(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(%Scope{} = scope, attrs) do
    %Comment{}
    |> Comment.changeset(attrs, scope)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  Only the comment author can update their own comments.

  ## Examples

      iex> update_comment(scope, comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(scope, comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Scope{} = scope, %Comment{} = comment, attrs) do
    true = comment.user_id == scope.user.id

    comment
    |> Comment.changeset(attrs, scope)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  Only the owner of the note (article) can delete comments on it.

  ## Examples

      iex> delete_comment(scope, comment)
      {:ok, %Comment{}}

  """
  def delete_comment(%Scope{} = _scope, %Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(scope, comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Scope{} = scope, %Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs, scope)
  end
end
