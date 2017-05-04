defmodule Mix.Tasks.Taten do

  @moduledoc """

    Lists the contributions of a github profile

    Usage:

      mix taten duksis # lists contributions of user duksis
  """

  @shortdoc "Lists the contributions of a github profile"

  use Mix.Task

  def run([]), do: usage
  def run(["--help"]), do: run([])
  def run(["-h"]), do: run([])
  def run([arg]) do
    [:postgrex, :ecto]
    |> Enum.each(&Application.ensure_all_started/1)
    Tentacat.start
    Githubarchive.Repo.start_link
    arg |> GuteTaten.retrieve |> Enum.map(&print/1)
  end
  def run(_), do: run([])

  defp usage do
    IO.puts @moduledoc
  end

  defp print(deed) do
    JSX.encode!(deed) |> JSX.prettify! |> IO.puts
  end
end
