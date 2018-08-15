defmodule Coap.MixProject do
  use Mix.Project

  def project do
    [
      app: :coap,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.0"},
      {:gen_coap, github: "gotthardp/gen_coap", only: [:dev, :test]}
    ]
  end
end
