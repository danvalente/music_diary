defmodule MusicDiary.MixProject do
  use Mix.Project

  def project do
    [
      app: :music_diary,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :spotify_ex],
      mod: {MusicDiary.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:spotify_ex, "~> 2.0.9"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
