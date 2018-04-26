defmodule GuteTatenTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest GuteTaten

  test "retrieve/1" do
    use_cassette "acceptance", match_requests_on: [:query] do
      json_output = """
      [
        {
          "description": "Allow multiple invitations on top of devise_invitable",
          "name": "Useful project",
          "reference": "https://github.com/RoxasShadow/devise_invitations",
          "stars": 10
        },
        {
          "description": "A dumper to download whole galleries from boards like 4chan, imagebam, mangaeden, deviantart, etc.",
          "name": "Useful project",
          "reference": "https://github.com/RoxasShadow/Dumper",
          "stars": 22
        },
        {
          "description": "A framework to make and manage backups of your database",
          "name": "Useful project",
          "reference": "https://github.com/RoxasShadow/EDB",
          "stars": 105
        }
      ]\
      """

      assert GuteTaten.retrieve("RoxasShadow") == json_output
    end
  end
end
