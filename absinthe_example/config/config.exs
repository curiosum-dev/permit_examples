import Config

config :absinthe_example,
  ecto_repos: [AbsintheExample.Repo]

config :absinthe_example, AbsintheExample.Repo,
  database: "absinthe_example_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool_size: 10

config :phoenix, :json_library, Jason

config :absinthe_example, AbsintheExample.Endpoint,
  url: [host: "localhost"],
  http: [port: 4000],
  secret_key_base: "your-secret-key-base-here-replace-in-production",
  server: true,
  render_errors: [formats: [json: AbsintheExample.ErrorView]]

import_config "#{config_env()}.exs"
