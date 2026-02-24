defmodule AbsintheExample.Content do
  alias AbsintheExample.Repo
  alias AbsintheExample.Content.{Note, Comment}

  # Notes

  def list_notes do
    Repo.all(Note)
  end

  def get_note(id) do
    Repo.get(Note, id)
  end

  def create_note(attrs) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  # Comments

  def list_comments do
    Repo.all(Comment)
  end

  def get_comment(id) do
    Repo.get(Comment, id)
  end

  def create_comment(attrs) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  # Dataloader sources

  def datasource do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  defp query(queryable, _params) do
    queryable
  end
end
