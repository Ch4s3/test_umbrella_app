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
    # Using :transitive pattern to automatically include all dependencies
    # This ensures all transitive dependencies are included, preventing
    # missing function errors in CI environments.
    # The core_apps are OTP apps that are handled by core PLTs.
    # The :transitive option automatically includes all project dependencies.
    [
      incremental: true,
      core_apps: [:erts, :kernel, :stdlib, :crypto, :elixir, :logger, :mix, :public_key],
      apps: :transitive,  # Automatically resolves to core_apps ++ all deps ++ project_apps
      warning_apps: :project,  # Only show warnings for project apps ([:web, :core])
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
