defmodule AbsintheExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AbsintheExample.Repo,
      {Phoenix.PubSub, name: AbsintheExample.PubSub},
      AbsintheExample.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AbsintheExample.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
