defmodule GuteTaten.GivingBackTheLove do
  def call(github_username, api \\ GuteTaten.Api) do
    api.call(Tentacat.Users.Events, :list_public, github_username)
    |> Enum.filter(fn(x) -> Map.fetch!(x, "type") == "PullRequestEvent" end)
    |> Enum.filter(fn(x) -> case x do %{"payload" => %{"action" => "opened"}} -> true ; _ -> false end; end)
    #   |> Enum.filter(fn(x) -> case x do %{"payload" => %{"pull_request" => %{"base" => %{"repo" => %{"owner" => %{"name" => github_username}}}}}} -> false ; _ -> true end; end)
    |> Enum.map(fn(x) -> %{ name: "Is contributing back", reference: Map.fetch!(Map.fetch!(Map.fetch!(x, "payload"), "pull_request"), "html_url")} end)
  end
end
