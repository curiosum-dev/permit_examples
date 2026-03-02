defmodule NotesWeb.NoteLive.Form do
  use NotesWeb, :live_view

  alias Notes.Content
  alias Notes.Content.Note

  @impl true
  def resource_module, do: Notes.Content.Note

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage note records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="note-form" phx-change="validate" phx-submit={@submit_action}>
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:content]} type="textarea" label="Content" />
        <.input field={@form[:public]} type="checkbox" label="Public" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Note</.button>
          <.button navigate={return_path(@current_scope, @return_to, @note)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:submit_action, %{new: "create", edit: "update"}[socket.assigns.live_action])
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    note = socket.assigns.loaded_resource

    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, note)
    |> assign(:form, to_form(Content.change_note(socket.assigns.current_scope, note)))
  end

  defp apply_action(socket, :new, _params) do
    note = %Note{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, note)
    |> assign(:form, to_form(Content.change_note(socket.assigns.current_scope, note)))
  end

  @impl true
  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset =
      Content.change_note(socket.assigns.current_scope, socket.assigns.note, note_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @permit_action :update
  def handle_event("update", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.live_action, note_params)
  end

  @permit_action :create
  def handle_event("create", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.live_action, note_params)
  end

  defp save_note(socket, :edit, note_params) do
    case Content.update_note(socket.assigns.current_scope, socket.assigns.note, note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, note)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_note(socket, :new, note_params) do
    case Content.create_note(socket.assigns.current_scope, note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, note)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _note), do: ~p"/notes"
  defp return_path(_scope, "show", note), do: ~p"/notes/#{note}"
end
