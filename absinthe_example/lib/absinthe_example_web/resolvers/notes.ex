defmodule AbsintheExampleWeb.Resolvers.Notes do
  alias AbsintheExample.Content

  def create_note(_parent, %{input: input}, %{context: %{current_user: user}}) do
    input
    |> Map.put(:user_id, user.id)
    |> Content.create_note()
    |> case do
      {:ok, note} -> {:ok, note}
      {:error, changeset} -> {:error, format_errors(changeset)}
    end
  end

  def create_note(_parent, _args, _resolution) do
    {:error, "Unauthorized"}
  end

  def update_note(_parent, %{input: input}, %{context: %{loaded_resource: note}}) do
    note
    |> Content.update_note(input)
    |> case do
      {:ok, note} -> {:ok, note}
      {:error, changeset} -> {:error, format_errors(changeset)}
    end
  end

  def delete_note(_parent, _args, %{context: %{loaded_resource: note}}) do
    case Content.delete_note(note) do
      {:ok, _note} -> {:ok, true}
      {:error, _changeset} -> {:error, "Failed to delete note"}
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
