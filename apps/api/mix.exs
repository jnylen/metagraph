defmodule Api.MixProject do
  use Mix.Project

  @name :api
  @version "0.1.0"

  @deps [
    {:phoenix, "~> 1.4.0"},
    {:phoenix_pubsub, "~> 1.1"},
    {:gettext, "~> 0.11"},
    {:jason, "~> 1.0"},
    {:plug_cowboy, "~> 2.0"},
    {:graph, in_umbrella: true},
    {:database, in_umbrella: true},

    # GraphQL
    {:absinthe, "~> 1.4"},
    {:absinthe_plug, "~> 1.4"}
    # {:absinthe_throttle, "~> 0.4.0"} # throttle queries
    # {:apq, "~> 1.0.0"} # caching queries
    # {:apollo_tracing, "~> 0.4.0"} # future?
  ]

  def project do
    [
      app: @name,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: @deps
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Api.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
