import Config

config :absinthe_example, AbsintheExample.Repo,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
