defmodule AbsintheExampleWeb.Schema do
  use Absinthe.Schema
  use Permit.Absinthe, authorization_module: AbsintheExample.Authorization

  import_types(Absinthe.Type.Custom)
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias AbsintheExampleWeb.Resolvers
  alias AbsintheExample.Content.{Note, Comment}
  alias AbsintheExample.Accounts.User

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(AbsintheExample.Content, AbsintheExample.Content.datasource())

    ctx
    |> Map.put(:loader, loader)
    |> Map.put(:current_user, ctx[:current_user])
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  # GraphQL Types

  object :user do
    permit(schema: User)

    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field(:inserted_at, non_null(:naive_datetime))
    field(:updated_at, non_null(:naive_datetime))

    field :notes, list_of(:note) do
      permit(action: :read)
      resolve(&authorized_dataloader/3)
    end

    field :comments, list_of(:comment) do
      permit(action: :read)
      resolve(&authorized_dataloader/3)
    end
  end

  object :note do
    permit(schema: Note)

    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:content, non_null(:string))
    field(:public, non_null(:boolean))
    field(:inserted_at, non_null(:naive_datetime))
    field(:updated_at, non_null(:naive_datetime))

    field(:user, non_null(:user), resolve: dataloader(AbsintheExample.Content))

    field :comments, list_of(:comment) do
      permit(action: :read)
      resolve(&authorized_dataloader/3)
    end
  end

  object :comment do
    permit(schema: Comment)

    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:content, non_null(:string))
    field(:inserted_at, non_null(:naive_datetime))
    field(:updated_at, non_null(:naive_datetime))

    field(:user, non_null(:user), resolve: dataloader(AbsintheExample.Content))
    field(:note, non_null(:note), resolve: dataloader(AbsintheExample.Content))
  end

  input_object :create_note_input do
    field(:title, non_null(:string))
    field(:content, non_null(:string))
    field(:public, :boolean, default_value: false)
  end

  input_object :update_note_input do
    field(:title, :string)
    field(:content, :string)
    field(:public, :boolean)
  end

  input_object :create_comment_input do
    field(:note_id, non_null(:id))
    field(:title, non_null(:string))
    field(:content, non_null(:string))
  end

  input_object :update_comment_input do
    field(:title, :string)
    field(:content, :string)
  end

  # Queries and Mutations

  query do
    field :notes, list_of(:note) do
      permit(action: :read)
      resolve(&load_and_authorize/2)
    end

    field :note, :note do
      arg(:id, non_null(:id))
      permit(action: :read)
      resolve(&load_and_authorize/2)
    end

    field :comments, list_of(:comment) do
      permit(action: :read)
      resolve(&load_and_authorize/2)
    end

    field :comment, :comment do
      arg(:id, non_null(:id))
      permit(action: :read)
      resolve(&load_and_authorize/2)
    end
  end

  mutation do
    field :create_note, :note do
      arg(:input, non_null(:create_note_input))
      permit(action: :create)
      middleware(Permit.Absinthe.Middleware)
      resolve(&Resolvers.Notes.create_note/3)
    end

    field :update_note, :note do
      arg(:id, non_null(:id))
      arg(:input, non_null(:update_note_input))
      permit(action: :update)
      middleware(Permit.Absinthe.Middleware)
      resolve(&Resolvers.Notes.update_note/3)
    end

    field :delete_note, :boolean do
      arg(:id, non_null(:id))
      permit(action: :delete)
      middleware(Permit.Absinthe.Middleware)
      resolve(&Resolvers.Notes.delete_note/3)
    end

    field :create_comment, :comment do
      arg(:input, non_null(:create_comment_input))
      permit(action: :create)
      middleware(Permit.Absinthe.Middleware)
      resolve(&Resolvers.Comments.create_comment/3)
    end

    field :update_comment, :comment do
      arg(:id, non_null(:id))
      arg(:input, non_null(:update_comment_input))
      permit(action: :update)
      middleware(Permit.Absinthe.Middleware)
      resolve(&Resolvers.Comments.update_comment/3)
    end

    field :delete_comment, :boolean do
      arg(:id, non_null(:id))
      permit(action: :delete)
      middleware(Permit.Absinthe.Middleware)
      resolve(&Resolvers.Comments.delete_comment/3)
    end
  end
end
