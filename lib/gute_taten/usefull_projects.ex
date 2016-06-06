defmodule GuteTaten.UsefullProjects do
  def call(github_username) do
    github_username
    |> Tentacat.Repositories.list_users
    |> Enum.filter(fn(x) -> Map.fetch!(x, "fork") == false end)
    |> Enum.filter(fn(x) -> Map.fetch!(x, "stargazers_count") >= 5 end)
    |> Enum.map(fn(x) -> %{ name: "Usefull project", reference: Map.fetch!(x, "html_url")} end)
  end
end
