defmodule Paramsx.MixProject do
  use Mix.Project

  def project do
    [
      app: :paramsx,
      version: "0.4.5",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: "Paramsx provides functionally to whitelist and validate parameters",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21.3", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "Paramsx",
      source_url: "https://github.com/BCecatto/Paramsx"
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["Bruno Cecatto"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/BCecatto/Paramsx"}
    ]
  end
end
