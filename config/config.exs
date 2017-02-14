# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :gute_taten,
  rules: ["UsefulProjects", "GivingBackTheLove", "GivingBackTheLoveV2"],
  github_token: System.get_env("GITHUB_TOKEN")


config :gute_taten, ecto_repos: [Githubarchive.Repo]

config :gute_taten, Githubarchive.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :gute_taten, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:gute_taten, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#
if Mix.env == :test do
  import_config "#{Mix.env}.exs"
end
