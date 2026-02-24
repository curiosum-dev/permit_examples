defmodule AbsintheExample.Repo do
  use Ecto.Repo,
    otp_app: :absinthe_example,
    adapter: Ecto.Adapters.Postgres
end
