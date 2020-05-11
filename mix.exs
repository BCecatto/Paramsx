defmodule Paramsx.MixProject do
  use Mix.Project

  def project do
    [
      app: :paramsx,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [{:credo, "~> 1.4", only: [:dev, :test], runtime: false}]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["Bruno Cecatto"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/BCecatto/Paramsx"},
      description: "Library to act like to Rails' strong parameters"
    ]
  end
end
