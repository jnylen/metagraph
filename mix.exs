defmodule Umbrella.MixProject do
  use Mix.Project

  @deps [
    {:pkg_deb, "~> 0.3"},
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
            api: :permanent,
            frontend: :permanent,
            database: :permanent,
            graph: :permanent,
            worker: :permanent
          ],
          steps: [:assemble, &PkgDeb.create(&1, deb_config())],
          config_providers: [{Config.Reader, "/etc/metagraph/metagraph.exs"}]
        ]
      ]
    ]
  end

  defp deb_config() do
    [
      vendor: "Joakim Nylén",
      maintainers: ["Joakim Nylén <joakim@pixelmonster.ee>"],
      homepage: "https://metagraph.wiki",
      base_path: "/opt",
      external_dependencies: [],
      owner: [user: "jnylen", group: "jnylen"],
      description: "Metagraph Application"
    ]
  end
end
