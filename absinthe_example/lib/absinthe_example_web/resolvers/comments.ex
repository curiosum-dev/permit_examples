defmodule AbsintheExampleWeb.Resolvers.Comments do
  alias AbsintheExample.Content

  def create_comment(_parent, %{input: %{note_id: note_id} = input}, %{
        context: %{current_user: user}
      }) do
    # Check if user can create comment on this note (note must be public)
    note = Content.get_note(note_id)

    with %{public: true} <- note do
      input
      |> Map.put(:user_id, user.id)
      |> Content.create_comment()
      |> case do
        {:ok, comment} -> {:ok, comment}
        {:error, changeset} -> {:error, format_errors(changeset)}
      end
    else
      nil -> {:error, "Note not found"}
      %{public: false} -> {:error, "Cannot comment on private note"}
    end
  end

  def create_comment(_parent, _args, _resolution) do
    {:error, "Unauthorized"}
  end

  def update_comment(_parent, %{input: input}, %{context: %{loaded_resource: comment}}) do
    comment
    |> Content.update_comment(input)
    |> case do
      {:ok, comment} -> {:ok, comment}
      {:error, changeset} -> {:error, format_errors(changeset)}
    end
  end

  def delete_comment(_parent, _args, %{context: %{loaded_resource: comment}}) do
    case Content.delete_comment(comment) do
      {:ok, _comment} -> {:ok, true}
      {:error, _changeset} -> {:error, "Failed to delete comment"}
    end
  end

  defp format_errors(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {message, _}} ->
      "#{field}: #{message}"
    end)
    |> Enum.join(", ")
  end
end
