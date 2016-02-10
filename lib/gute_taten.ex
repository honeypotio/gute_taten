defmodule GuteTaten do
  @doc """
  Retrieves a list of good deeds for a given github username

  ## Example
      GuteTaten.retrieve("duksis")
  """

  @spec retrieve(binary) :: binary
  def retrieve(github_identity) do
    Tentacat.start
    github_identity
      |> search_deeds
      |> format_output
  end

  @spec search_deeds(binary) :: [map]
  defp search_deeds(github_username) do
    Enum.map([github_username], fn(x) -> [usefull_project(x), giving_back_the_love(x)] end)
      |> List.flatten
  end

  defp usefull_project(github_username) do
    github_username
      |> Tentacat.Repositories.list_users
      |> Enum.filter(fn(x) -> Map.fetch!(x, "fork") == false end)
      |> Enum.filter(fn(x) -> Map.fetch!(x, "stargazers_count") >= 5 end)
      |> Enum.map(fn(x) -> %{ name: "Usefull project", reference: Map.fetch!(x, "html_url")} end)
  end

  defp giving_back_the_love(github_username) do
    github_username
      |> Tentacat.Users.Events.list_public
      |> Enum.filter(fn(x) -> Map.fetch!(x, "type") == "PullRequestEvent" end)
      |> Enum.filter(fn(x) -> case x do %{"payload" => %{"action" => "opened"}} -> true ; _ -> false end; end)
      |> Enum.map(fn(x) -> %{ name: "Is contributing back", reference: Map.fetch!(Map.fetch!(Map.fetch!(x, "payload"), "pull_request"), "html_url")} end)
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
