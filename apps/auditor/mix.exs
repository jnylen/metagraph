defmodule Auditor.MixProject do
  use Mix.Project

  @name :auditor
  @version "0.1.0"

  @deps [
    {:telemetry, "~> 0.4.0"},
    {:database, in_umbrella: true},
    {:map_diff, "~> 1.3", git: "https://github.com/jnylen/elixir_map_diff.git"}
  ]

  def project do
    [
      app: @name,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: @deps
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Auditor.Application, []}
    ]
  end
end
