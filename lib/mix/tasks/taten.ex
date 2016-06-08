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
    Tentacat.start
    arg |> GuteTaten.retrieve |> IO.puts
  end
  def run(_), do: run([])

  defp usage do
    IO.puts @moduledoc
  end
end
