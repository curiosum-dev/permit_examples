defmodule NotesWeb.NoteLive.Show do
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
        Note {@loaded_resource.id}
        <:subtitle>This is a note record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/notes"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <%= if can(@current_scope.user) |> edit?(@loaded_resource) do %>
            <.button variant="primary" navigate={~p"/notes/#{@loaded_resource}/edit?return_to=show"}>
              <.icon name="hero-pencil-square" /> Edit note
            </.button>
          <% end %>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@loaded_resource.name}</:item>
        <:item title="Content">{@loaded_resource.content}</:item>
        <:item title="Public">{if @loaded_resource.public, do: "Yes", else: "No"}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Note")}
  end

  @impl true
  def handle_info(
        {:updated, %Notes.Content.Note{id: id} = note},
        %{assigns: %{note: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :note, note)}
  end

  def handle_info(
        {:deleted, %Notes.Content.Note{id: id}},
        %{assigns: %{note: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current note was deleted.")
     |> push_navigate(to: ~p"/notes")}
  end

  def handle_info({type, %Notes.Content.Note{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
