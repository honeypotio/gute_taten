defmodule GuteTaten.Api do
  @spec call([atom], atom, list) :: any
  def call(module, function, arguments) do
    Code.eval_quoted(
      {{:., [],
        [{:__aliases__, [alias: false], module}, function]},
        [], arguments}
    )
  end
end
