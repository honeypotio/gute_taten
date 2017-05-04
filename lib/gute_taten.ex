defmodule GuteTaten do
  @doc """
  Retrieves a list of good deeds for a given github username

  ## Example
      GuteTaten.retrieve("duksis")
  """

  @default_rules ["UsefulProjects", "GivingBackTheLove"]
  @rules Application.get_env(:gute_taten, :rules, @default_rules)

  @spec retrieve(binary, [binary]) :: [map]
  def retrieve(username, rules \\ @rules) do
    Stream.flat_map(rules, fn(x) -> Module.concat(__MODULE__, x).call(username) end)
  end
end
