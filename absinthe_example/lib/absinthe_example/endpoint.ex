defmodule AbsintheExample.Endpoint do
  use Phoenix.Endpoint, otp_app: :absinthe_example

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(AbsintheExample.Router)
end
