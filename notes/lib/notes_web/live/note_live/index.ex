defmodule NotesWeb.NoteLive.Index do
  use NotesWeb, :live_view

  alias Notes.Content

  import Notes.Authorization

  @impl true
  def resource_module, do: Notes.Content.Note

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Notes
        <:actions>
          <.button variant="primary" navigate={~p"/notes/new"}>
            <.icon name="hero-plus" /> New Note
          </.button>
        </:actions>
      </.header>

      <.table
        id="notes"
        rows={@streams.loaded_resources}
        row_click={fn {_id, note} -> JS.navigate(~p"/notes/#{note}") end}
      >
        <:col :let={{_id, note}} label="Name">{note.name}</:col>
        <:col :let={{_id, note}} label="Content">{note.content}</:col>
        <:col :let={{_id, note}} label="Public">
          <%= if note.public do %>
            <.icon name="hero-check-circle" class="w-5 h-5 text-green-600" />
          <% else %>
            <.icon name="hero-x-circle" class="w-5 h-5 text-gray-400" />
          <% end %>
        </:col>
        <:action :let={{_id, note}}>
          <%= if can(@current_scope.user) |> show?(note) do %>
            <div class="sr-only">
              <.link navigate={~p"/notes/#{note}"}>Show</.link>
            </div>
          <% end %>
          <%= if can(@current_scope.user) |> edit?(note) do %>
            <.link navigate={~p"/notes/#{note}/edit"}>Edit</.link>
          <% end %>
        </:action>
        <:action :let={{id, note}}>
          <%= if can(@current_scope.user) |> delete?(note) do %>
            <.link
              phx-click={JS.push("delete", value: %{id: note.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          <% end %>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Notes")}
  end

  @impl true
  @permit_action :delete
  def handle_event("delete", %{"id" => id}, socket) do
    note = socket.assigns.loaded_resource
    {:ok, _} = Content.delete_note(socket.assigns.current_scope, note)

    {:noreply, stream_delete(socket, :loaded_resources, note)}
  end

  @impl true
  def handle_info({type, %Notes.Content.Note{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, stream(socket, :notes, list_notes(socket.assigns.current_scope), reset: true)}
  end

  defp list_notes(current_scope) do
    Content.list_notes(current_scope)
  end
end
