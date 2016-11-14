defmodule Knit.Mixfile do
  use Mix.Project

  def project do
    [app: :knit,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :exconstructor]]
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
    [{:exconstructor, "~> 1.0.2"}]
  end

  defp description do
    """
    Transforms string maps into nested structs: knits strings into something useful.
    """
  end

  defp package do
    [name: :knit,
     maintainers: ["Will Ockelmann-Wagner"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/whenther/knit"}]
  end
end
