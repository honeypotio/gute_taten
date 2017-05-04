defmodule GuteTaten.UsefulProjects do
  def call(github_username) do
    github_username
    |> user_public_repos(client)
    |> Stream.filter(fn(x) -> Map.fetch!(x, "fork") == false end)
    |> Stream.filter(fn(x) -> Map.fetch!(x, "stargazers_count") >= 5 end)
    |> Stream.map(fn(x) -> %{ name: "Useful project", reference: Map.fetch!(x, "html_url"), description: Map.fetch!(x, "description"), stars: Map.fetch!(x, "stargazers_count")} end)
  end

  defp client do
    case Application.get_env(:gute_taten, :github_token) do
      nil -> %Tentacat.Client{}
      token -> Tentacat.Client.new(%{access_token: token})
    end
  end

  defp user_public_repos(owner, client) do
    Tentacat.get "users/#{owner}/repos", client, [], [pagination: :stream]
  end
end
