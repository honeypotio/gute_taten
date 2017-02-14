defmodule GuteTaten.GivingBackTheLoveV2 do
  import Ecto.Query
  alias Githubarchive.Event
  alias Githubarchive.Repo

  def call(github_username, api \\ GuteTaten.Api) do
    # api.call([:Tentacat, :Users, :Events], :list_public, [github_username])
    pull_request_open_events(github_username)
    |> Enum.filter(&exclude_user(&1, github_username))
    |> Enum.map(fn(x) -> %Event{payload: %{"pull_request" => %{"html_url" => html_url}}} = x; %{ name: "Is contributing back", reference: html_url} end)
    |> Enum.filter(&has_been_merged(&1, api))
  end

  defp pull_request_open_events(user) do
    # SELECT created_at, payload -> 'pull_request' -> 'html_url' AS pr
    # FROM events
    # WHERE actor ->> 'login' = 'josevalim';
    Event
    |> where(fragment("actor ->> 'login' = ?", ^user))
    |> Repo.all
  end

  defp exclude_user(event, user) do
    path = "https://github.com/" <> user
    path_size = byte_size(path)
    case event do
      # https://github.com/elixir-lang/elixir/issues/3837
      %{"payload" => %{"pull_request" => %{"html_url" =>  <<^path::binary-size(path_size)>> <> _}}} -> false
      _ -> true
    end
  end

  defp has_been_merged(%{reference: "https://github.com/" <> path}, api) do
    [user, repo, _, nr] = String.split(path, "/")
    #case api.call([:Tentacat, :Pulls], :has_been_merged, [user, repo, nr]) do
    case Tentacat.Pulls.has_been_merged(user, repo, nr, client) do
      {204, _} -> true
      _ -> false
    end
  end

  defp client do
    case Application.get_env(:gute_taten, :github_token) do
      nil -> %Tentacat.Client{}
      token -> Tentacat.Client.new(%{access_token: token})
    end
  end
end
