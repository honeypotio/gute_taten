defmodule GuteTaten.GivingBackTheLoveTest do
  use ExUnit.Case, async: true

  doctest GuteTaten.GivingBackTheLove

  def api_double_module(name) do
    module = Module.concat(__MODULE__, name)
    contents = quote do
      def call(_module, _fun, _args) do
        [%{
          "type" => "PullRequestEvent",
          "payload" => %{"action" => "opened", "pull_request" => %{"html_url" => "https://github.com/RoxasShadow/devise_invitations"}}
        }]
      end
    end
    Module.create(module, contents, Macro.Env.location(__ENV__))
    module
  end

  test "filters PR's" do
    api_double = api_double_module("FiltersPRs")
    expected_output = [%{
      name: "Is contributing back",
      reference: "https://github.com/RoxasShadow/devise_invitations"
    }]
    assert GuteTaten.GivingBackTheLove.call("RoxasShadow", api_double) == expected_output
  end
end
