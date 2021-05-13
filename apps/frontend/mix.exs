defmodule Frontend.MixProject do
  use Mix.Project

  @name :frontend
  @version "0.1.0"

  @deps [
    # , "~> 1.4"
    {:phoenix, "~> 1.5.2"},
    # , "~> 0.10"
    {:phoenix_live_view, "~> 0.14.1"},
    # {:phoenix_pubsub, "~> 1.1"},
    # {:phoenix_html, "~> 2.14"},
    {:phoenix_live_reload, "~> 1.2", only: :dev},
    {:phoenix_active_link, "~> 0.3"},
    {:phoenix_html_simplified_helpers, ">= 0.0.0"},
    {:phoenix_ecto, "~> 4.1"},
    {:gettext, "~> 0.11"},
    {:jason, "~> 1.0"},
    {:plug_cowboy, "~> 2.2"},
    {:canada, "~> 2.0"},
    {:floki, ">= 0.0.0", only: :test},
    {:hcaptcha, "~> 0.0.1"},

    # Database
    {:database, in_umbrella: true},
    {:graph, in_umbrella: true},
    {:editor, in_umbrella: true},
    {:authorization, in_umbrella: true},
    {:cowlib, "~> 2.11.0", override: true},
    {:logger_file_backend_with_formatters, "~> 0.0.1"},

    # Pagination
    {:scrivener_html_semi, "~> 3.0"}
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
      mod: {Frontend.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
