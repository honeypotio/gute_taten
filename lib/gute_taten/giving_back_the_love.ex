defmodule GuteTaten.GivingBackTheLove do

  def call(github_username, api \\ GuteTaten.Api) do
    # api.call([:Tentacat, :Users, :Events], :list_public, [github_username])
    Tentacat.Users.Events.list_public(github_username, client)
    |> Enum.filter(&pull_request_event/1)
    |> Enum.filter(&open_pr/1)
    |> Enum.filter(&exclude_user(&1, github_username))
    |> Enum.filter(&has_been_merged/1)
    |> Enum.map(fn(x) -> %{ name: "Is contributing back", reference: html_url(x), description: description(x), stars: stars(x)} end)
  end

  defp has_been_merged(%{"merged_at" => nil}), do: false
  defp has_been_merged(_), do: true

  defp open_pr(%{"payload" => %{"action" => "opened"}}), do: true
  defp open_pr(_), do: false

  defp pull_request_event(%{"type" => "PullRequestEvent"}), do: true
  defp pull_request_event(_), do: false

  defp html_url(%{"payload" => %{"pull_request" => %{"html_url" => url}}}), do: url

  defp description(%{"payload" => %{"pull_request" => %{"base" => %{"repo" => %{"description" => desc}}}}}), do: desc

  defp stars(%{"payload" => %{"pull_request" => %{"base" => %{"repo" => %{"stargazers_count" => star_count}}}}}), do: star_count

  defp exclude_user(event, user) do
    path = "https://github.com/" <> user
    path_size = byte_size(path)
    case event do
      # https://github.com/elixir-lang/elixir/issues/3837
      %{"payload" => %{"pull_request" => %{"html_url" =>  <<^path::binary-size(path_size)>> <> _}}} -> false
      _ -> true
    end
  end

  defp client do
    case Application.get_env(:gute_taten, :github_token) do
      nil -> %Tentacat.Client{}
      token -> Tentacat.Client.new(%{access_token: token})
    end
  end
end
