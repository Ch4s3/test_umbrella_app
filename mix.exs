defmodule TestUmbrellaApp.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      listeners: [Phoenix.CodeReloader],
      dialyzer: dialyzer_config()
    ]
  end

  defp dialyzer_config do
    # OTP apps that should be included in apps (per Dialyzer incremental mode design)
    otp_apps = [
      :erts,
      :kernel,
      :stdlib,
      :elixir,
      :logger
    ]

    [
      incremental: [
        enabled: true,
        # Combine OTP apps with :app_tree and project apps
        # :app_tree expands to all transitive dependencies + project apps
        apps: otp_apps ++ [:app_tree],
        warning_apps: :apps_project  # Only show warnings for project apps
      ],
      flags: [:no_improper_lists, :no_opaque]
    ]
  end

  def cli do
    [
      preferred_envs: [precommit: :test]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp deps do
    [
      # Required to run "mix format" on ~H/.heex files from the umbrella root
      {:phoenix_live_view, ">= 0.0.0"},
      {:dialyxir, git: "https://github.com/Ch4s3/dialyxir.git", branch: "incremental", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"],
      precommit: ["compile --warning-as-errors", "deps.unlock --unused", "format", "test"]
    ]
  end
end
