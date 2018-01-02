defmodule Checkout.Mixfile do
  use Mix.Project

  def project do
    [
      app: :checkout,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      build_embedded: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test]
    ]
  end

  def application do
    [
      extra_applications: [
        :logger, 
        :ex_machina
      ],
      mod: {OnlineStore.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_machina, "~> 2.1"},
      {:money, "~> 1.2.1"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.8", only: :test}
    ]
  end
end
