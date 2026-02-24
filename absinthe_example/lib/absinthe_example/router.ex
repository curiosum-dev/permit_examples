defmodule AbsintheExample.Router do
  use Phoenix.Router

  pipeline :api do
    plug(AbsintheExampleWeb.Plugs.Authenticate)
  end

  scope "/api" do
    pipe_through(:api)

    forward("/graphql", Absinthe.Plug,
      schema: AbsintheExampleWeb.Schema,
      json_codec: Jason
    )

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: AbsintheExampleWeb.Schema,
      interface: :simple,
      json_codec: Jason
    )
  end
end
