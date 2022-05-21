defmodule Tictactoe.MixProject do
  use Mix.Project

  def project do
    [
      app: :tictactoe,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext, :phoenix_live_view] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Tictactoe.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 3.1.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
      {:ecto, "~> 3.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:ex_zample, github: "ulissesalmeida/ex_zample"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
end
