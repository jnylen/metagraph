defmodule Graph.MixProject do
  use Mix.Project

  @name :graph
  @version "0.1.0"

  @deps [
    {:jason, "~> 1.0"},
    {:dlex, "~> 0.4", github: "metagraph-wiki/dlex"},
    {:database, in_umbrella: true},
    {:gun, "~> 2.0.0", override: true, hex: :grpc_gun}
  ]

  def project do
    [
      app: @name,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: @deps
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Graph.Application, []}
    ]
  end
end
