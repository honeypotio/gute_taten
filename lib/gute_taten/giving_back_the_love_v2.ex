defmodule GuteTaten.GivingBackTheLoveV2 do
  import Ecto.Query
  alias Githubarchive.Event
  alias Githubarchive.Repo

  def call(github_username, _api \\ GuteTaten.Api) do
    pull_request_open_events(github_username)
    |> Stream.filter(&exclude_user(&1, github_username))
    |> Stream.map(&event_to_pr/1)
    |> Stream.filter(&has_been_merged/1)
    |> Stream.map(fn(x) -> %{ name: "Is contributing back", reference: Map.fetch!(x, "html_url"), description: description(x), stars: stars(x)} end)
    |> Stream.take(2)
  end

  defp pull_request_open_events(user) do
    # SELECT created_at, payload -> 'pull_request' -> 'html_url' AS pr
    # FROM events
    # WHERE actor ->> 'login' = 'josevalim';
    Event
    |> where(fragment("actor ->> 'login' = ?", ^user))
    |> Repo.all
  end

  defp event_to_pr(%Event{payload: %{"pull_request" => %{"html_url" => "https://github.com/" <> path}}}) do
    [user, repo, _, nr] = String.split(path, "/")
    case Tentacat.Pulls.find(user, repo, nr, client) do
      {301, %{"url" => url}} -> Tentacat._request(:get, url, client.auth)
      {302, %{"url" => url}} -> Tentacat._request(:get, url, client.auth)
      pr -> pr
    end
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

  defp stars(%{"base" => %{"repo" => %{"stargazers_count" => star_count}}}), do: star_count

  defp description(%{"base" => %{"repo" => %{"description" => desc}}}), do: desc

  defp has_been_merged(%{"merged_at" => nil}), do: false
  defp has_been_merged(%{"merged_at" => _}), do: true
  defp has_been_merged(_), do: false

  defp client do
    case Application.get_env(:gute_taten, :github_token) do
      nil -> %Tentacat.Client{}
      token -> Tentacat.Client.new(%{access_token: token})
    end
  end
end
