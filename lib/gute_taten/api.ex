defmodule GuteTaten.Api do
  def call(module, function, arguments) do
    Code.eval_quoted(
      {{:., [],
        [{:__aliases__, [alias: false], Module.split(module)}, function]},
        [], arguments}
    )
  end
end
