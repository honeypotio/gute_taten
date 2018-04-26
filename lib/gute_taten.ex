defmodule GuteTaten do
  @doc """
  Retrieves a list of good deeds for a given github username

  ## Example
      GuteTaten.retrieve("duksis")
  """

  @default_rules ["UsefulProjects", "GivingBackTheLove"]
  @rules Application.get_env(:gute_taten, :rules, @default_rules)

  @spec retrieve(binary) :: binary
  def retrieve(github_identity) do
    github_identity
      |> search_deeds
      |> format_output
  end

  @spec search_deeds(binary, [binary]) :: [map]
  defp search_deeds(github_username, rules \\ @rules) do
    Enum.map(rules, fn(x) -> Module.concat(__MODULE__, x).call(github_username) end)
      |> List.flatten
  end

  @spec format_output([map]) :: binary
  defp format_output(response) do
    #TODO implement cofigurable output formaters csv, json ...
    response |> to_json
  end

  @spec to_json([map]) :: binary
  defp to_json(deeds) do
    deeds |> JSX.encode! |> JSX.prettify!
  end
end
