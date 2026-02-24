import Config

config :absinthe_example, AbsintheExample.Repo,
  database: "absinthe_example_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  log: false
