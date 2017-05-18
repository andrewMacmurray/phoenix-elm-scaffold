defmodule Mix.Tasks.Elm.Test do
  use Mix.Task

  @shortdoc "runs elm test from within mix"

  def run(_argv) do
    cmd = "cd test/elm && elm-test Main.elm"
    Mix.shell.cmd(cmd, stderr_to_stdout: true)
  end
end
