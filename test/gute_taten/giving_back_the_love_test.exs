defmodule GuteTaten.GivingBackTheLoveTest do
  use ExUnit.Case, async: true

  doctest GuteTaten.GivingBackTheLove

  def api_double_module(name, value) do
    module = Module.concat(__MODULE__, name)
    contents = quote do
      def call(mod, fun, args) do
        case [mod, fun, args] do
          [[:Tentacat, :Pulls], :has_been_merged, [_, "devise", "1"]] -> {204, "Merged"}
          [[:Tentacat, :Pulls], :has_been_merged, _] -> {404, "Not Found"}
          _ -> unquote(Macro.escape(value))
        end
      end
    end
    Module.create(module, contents, Macro.Env.location(__ENV__))
    module
  end

  #  test "filters non PR's" do
  #    api_response = [
  #      %{
  #        "type" => "PullRequestEvent",
  #        "payload" => %{"action" => "opened", "pull_request" => %{"html_url" => "https://github.com/platformatec/devise/pull/1"}}
  #      },
  #      %{"type" => "Event"}
  #    ]
  #    api_double = api_double_module("FiltersPRs", api_response)
  #    expected_output = [%{
  #      name: "Is contributing back",
  #      reference: "https://github.com/platformatec/devise/pull/1"
  #    }]
  #    assert GuteTaten.GivingBackTheLove.call("RoxasShadow", api_double) == expected_output
  #  end
  #
  #  test "filters PR closed events" do
  #    api_response = [
  #      %{
  #        "type" => "PullRequestEvent",
  #        "payload" => %{"action" => "opened", "pull_request" => %{"html_url" => "https://github.com/platformatec/devise/pull/1"}}
  #      },
  #      %{
  #        "type" => "PullRequestEvent",
  #        "payload" => %{"action" => "closed"}
  #      }
  #    ]
  #    api_double = api_double_module("FiltersPROpenedEvents", api_response)
  #    expected_output = [%{
  #      name: "Is contributing back",
  #      reference: "https://github.com/platformatec/devise/pull/1"
  #    }]
  #    assert GuteTaten.GivingBackTheLove.call("RoxasShadow", api_double) == expected_output
  #  end
  #
  #  test "filters PR's to own repos" do
  #    api_response = [
  #      %{
  #        "type" => "PullRequestEvent",
  #        "payload" => %{"action" => "opened", "pull_request" => %{"html_url" => "https://github.com/platformatec/devise/pull/1"}}
  #      },
  #      %{
  #        "type" => "PullRequestEvent",
  #        "payload" => %{"action" => "opened", "pull_request" => %{"html_url" => "https://github.com/RoxasShadow/devise/pull/1"}}
  #      }
  #    ]
  #    api_double = api_double_module("FiltersOwnPRs", api_response)
  #    expected_output = [%{
  #      name: "Is contributing back",
  #      reference: "https://github.com/platformatec/devise/pull/1"
  #    }]
  #    assert GuteTaten.GivingBackTheLove.call("RoxasShadow", api_double) == expected_output
  #  end
  #
  #  test "filters merged PR" do
  #    api_response = [
  #      %{
  #        "type" => "PullRequestEvent",
  #        "payload" => %{"action" => "opened", "pull_request" => %{"html_url" => "https://github.com/platformatec/devise/pull/1"}}
  #      },
  #      %{
  #        "type" => "PullRequestEvent",
  #        "payload" => %{"action" => "opened", "pull_request" => %{"html_url" => "https://github.com/platformatec/devise/pull/2"}}
  #      }
  #    ]
  #    api_double = api_double_module("FiltersMergedPRs", api_response)
  #    expected_output = [%{
  #      name: "Is contributing back",
  #      reference: "https://github.com/platformatec/devise/pull/1"
  #    }]
  #    assert GuteTaten.GivingBackTheLove.call("RoxasShadow", api_double) == expected_output
  #  end
end
