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
        }
      ]\
      """

      assert GuteTaten.retrieve("RoxasShadow") == json_output
    end
  end
end
