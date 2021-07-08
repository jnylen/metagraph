defmodule Authorization.MixProject do
  use Mix.Project

  @name :authorization
  @version "0.1.0"
  @deps [
    {:ueberauth, "~> 0.5"},

    # Username/Password
    {:ueberauth_identity, "~> 0.2", github: "jnylen/ueberauth_identity"},

    # Hashing
    {:bcrypt_elixir, "~> 2.0"},

    # JWT
    {:guardian, "~> 2.0"}
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
      extra_applications: [:logger]
    ]
  end
end
