defmodule ElmGen.Mixfile do
  use Mix.Project

  def project do
    [app: :elm_gen,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:phoenix, "~> 1.3.0-rc"},
     {:ex_doc, "~> 0.14", only: :dev}]
  end
end
