defmodule GuteTatenTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest GuteTaten

  test "retrieve/1" do
    use_cassette "acceptance", match_requests_on: [:query] do
      json_output = """
      [
        {
          "name": "Usefull project",
          "reference": "https://github.com/RoxasShadow/devise_invitations"
        },
        {
          "name": "Usefull project",
          "reference": "https://github.com/RoxasShadow/Dumper"
        },
        {
          "name": "Usefull project",
          "reference": "https://github.com/RoxasShadow/EDB"
        },
        {
          "name": "Usefull project",
          "reference": "https://github.com/RoxasShadow/Pasteling"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/reem/iron-test/pull/29"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/RoxasShadow/iron-test/pull/1"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/17"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/16"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/15"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/14"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/13"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/12"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/10"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/9"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/benashford/rs-es/pull/7"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/OpenCode/awesome-regex/pull/5"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/OpenCode/awesome-regex/pull/4"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/OpenCode/awesome-regex/pull/3"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/OpenCode/awesome-regex/pull/2"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/owncloud/android/pull/1418"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/owncloud/gallery/pull/491"
        }
      ]\
      """

      assert GuteTaten.retrieve("RoxasShadow") == json_output
    end
  end
end
