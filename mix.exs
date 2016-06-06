defmodule GuteTaten.Mixfile do
  use Mix.Project

  def project do
    [app: :gute_taten,
     version: "0.0.1",
     elixir: "~> 1.2",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :tentacat]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:tentacat, "~> 0.5"},
      {:excoveralls, "~> 0.4", only: :test},
      {:mock, "~> 0.1.1", only: :test},
      {:exvcr, "~> 0.6", only: :test}
    ]
  end

  defp description do
    """
    A tool to parse "meaningfull" open source contributions
    out of forks and private notes on a github profile
    """
  end

  defp package do
    [
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Hugo Duksis"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/hoenypotio/gute_taten"}
    ]
  end
end
