defmodule Umbrella.MixProject do
  use Mix.Project

  @deps [
    {:cowlib, "~> 2.11.0", override: true},
    {:yamerl, "~> 0.7"}
  ]

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: @deps,
      version: File.read!("VERSION") |> String.trim(),
      releases: [
        metagraph: [
          include_executables_for: [:unix],
          applications: [
            runtime_tools: :permanent,
            frontend: :permanent,
            database: :permanent,
            graph: :permanent,
            worker: :permanent
          ],
          steps: [:assemble]
        ]
      ]
    ]
  end
end
