defmodule AbsintheExample.MixProject do
  use Mix.Project

  def project do
    [
      app: :absinthe_example,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AbsintheExample.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.7.0"},
      {:phoenix_html, "~> 4.0"},
      {:plug_cowboy, "~> 2.5"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:absinthe, "~> 1.7.10"},
      {:absinthe_plug, "~> 1.5"},
      {:dataloader, "~> 2.0"},
      {:jason, "~> 1.2"},
      {:permit, "~> 0.3.3"},
      {:permit_ecto, "~> 0.2.4"},
      {:permit_absinthe, "~> 0.2.0"}
    ]
  end
end
