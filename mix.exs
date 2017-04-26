defmodule Zuck.Mixfile do
  use Mix.Project

  def project do
    [app: :zuck,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: "Tiny library for the Facebook Graph API",
     package: [
       maintainers: ["Mohamed Boudra"],
       licenses: ["MIT"],
       links: %{ "Github" => "https://github.com/boudra/zuck" },
       files: ~w(lib README.md mix.exs LICENSE.md)
     ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger,:hackney]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:poison, "~> 3.0"},
      {:hackney, "~> 1.8.0"}
    ]
  end
end
