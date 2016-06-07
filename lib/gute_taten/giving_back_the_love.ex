defmodule GuteTaten.GivingBackTheLove do
  def call(github_username, api \\ GuteTaten.Api) do
    api.call([:Tentacat, :Users, :Events], :list_public, [github_username])
    |> Enum.filter(&pull_request_event/1)
    |> Enum.filter(&open_pr/1)
    |> Enum.filter(&exclude_user(&1, github_username))
    |> Enum.map(fn(x) -> %{ name: "Is contributing back", reference: Map.fetch!(Map.fetch!(Map.fetch!(x, "payload"), "pull_request"), "html_url")} end)
    |> Enum.filter(&has_been_merged(&1, api))
  end

  defp has_been_merged(%{reference: "https://github.com/" <> path}, api) do
    [user, repo, _, nr] = String.split(path, "/")
    case api.call([:Tentacat, :Pulls], :has_been_merged, [user, repo, nr]) do
      {204, _} -> true
      _ -> false
    end
  end

  defp open_pr(%{"payload" => %{"action" => "opened"}}), do: true
  defp open_pr(_), do: false

  defp pull_request_event(%{"type" => "PullRequestEvent"}), do: true
  defp pull_request_event(_), do: false

  defp exclude_user(event, user) do
    path = "https://github.com/" <> user
    path_size = byte_size(path)
    case event do
      # https://github.com/elixir-lang/elixir/issues/3837
      %{"payload" => %{"pull_request" => %{"html_url" =>  <<^path::binary-size(path_size)>> <> _}}} -> false
      _ -> true
    end
  end
end
