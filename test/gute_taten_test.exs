defmodule GuteTatenTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  doctest GuteTaten

  test "retrieve/1" do
    use_cassette "acceptance" do
      json_output = """
      [
        {
          "name": "Usefull project",
          "reference": "https://github.com/duksis/Latvian-pounded.keylayout"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/jjh42/mock/pull/36"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/jjh42/mock/pull/35"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/jjh42/mock/pull/34"
        },
        {
          "name": "Is contributing back",
          "reference": "https://github.com/mrvautin/adminMongo/pull/2"
        }
      ]\
      """

      assert GuteTaten.retrieve("duksis") == json_output
    end
  end
end
