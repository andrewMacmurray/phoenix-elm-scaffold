defmodule ElmScaffold.Mixfile do
  use Mix.Project

  @github_url "https://github.com/andrewMacmurray/phoenix-elm-scaffold"

  def project do
    [app: :phoenix_elm_scaffold,
     name: "Phoenix Elm Scaffold",
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package(),
     docs: docs(),
     source_url: @github_url,
     homepage_url: @github_url]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:phoenix, "~> 1.3.0"},
     {:ex_doc, "~> 0.14", only: :dev}]
  end

  defp description do
    """
    A mix task to generate scaffolding for an elm app inside a Phoenix (1.3) app
    """
  end

  defp package do
    [
      maintainers: ["Andrew MacMurray"],
      licenses: ["BSD3"],
      links: %{"GitHub" => @github_url},
      source_url: @github_url
    ]
  end

  defp docs do
    [
      logo: "priv/static/elm-logo.png",
      extras: ["README.md"]
    ]
  end
end
