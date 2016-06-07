defmodule GuteTaten.GivingBackTheLoveTest do
  use ExUnit.Case, async: true

  doctest GuteTaten.GivingBackTheLove

  def api_double_module(name, value) do
    module = Module.concat(__MODULE__, name)
    contents = quote do
      def call(_module, _fun, _args), do: unquote(Macro.escape(value))
    end
    Module.create(module, contents, Macro.Env.location(__ENV__))
    module
  end

  test "filters PR's" do
    api_response = [
      %{
        "type" => "PullRequestEvent",
        "payload" => %{"action" => "opened", "pull_request" => %{"html_url" => "https://github.com/RoxasShadow/devise_invitations"}}
      }
    ]
    api_double = api_double_module("FiltersPRs", api_response)
    expected_output = [%{
      name: "Is contributing back",
      reference: "https://github.com/RoxasShadow/devise_invitations"
    }]
    assert GuteTaten.GivingBackTheLove.call("RoxasShadow", api_double) == expected_output
  end
end
