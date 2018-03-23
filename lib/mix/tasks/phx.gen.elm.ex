defmodule Mix.Tasks.Phx.Gen.Elm do
  use Mix.Task

  @shortdoc "Generates an elm app inside a Phoenix (1.3) app with the necessary scaffolding"
  @instructions """
    1. add the following to the `plugins` section of your `brunch-config.js`

      ```js
      elmBrunch: {
        elmFolder: '.',
        mainModules: ['elm/Main.elm'],
        outputFile: 'elm.js',
        outputFolder: '../assets/js',
        makeParameters: ['--debug'] // optional debugger for development
      }
      ```

    2. add `elm` to the `watched` array in your `brunch-config.js`
       You may also want to add `/elm\\.js/` to the babel ignore pattern to speed up compilation

      ```js
      babel: {
        ignore: [/vendor/, /elm\.js/]
      }
      ```


    3. in your `app.js` file add the following

      ```js
      import ElmApp from './elm.js'
      import elmEmbed from './elm-embed.js'

      elmEmbed.init(ElmApp)
      ```

    4. and finally in your `router.ex` file add

      ```elixir
      get "/path-to-elm-app", ElmController, :index
      ```
  """

  @moduledoc """
  Generates an elm app inside a Phoenix (1.3) app with the necessary scaffolding

  adds:
  - elm files (`Main`, `Model`, `View`, `Update`)
  - an embed script
  - `elm-package.json`
  - A phoenix `controller`, `view` and `template`
  - an `elm-test` setup

  to run the generator:

  ```sh
  > mix phx.gen.elm
  ```
  then follow post install instructions:

  #{@instructions}

  """

  @src "priv/templates/phx.gen.elm"

  def run(_argv) do
    copy_phoenix_files()
    copy_elm_files()
    install_node_modules()
    post_install_instructions()
    update_time_created()
  end

  defp post_install_instructions do
    instructions = """

    🎉 ✨  Your elm app is almost ready to go! ✨ 🎉

    #{@instructions}

    """

    Mix.shell.info(instructions)
  end


  defp copy_phoenix_files do
    templates = [
      {:eex, "views/elm_view.ex",             web_dir("views/elm_view.ex")},
      {:eex, "controllers/elm_controller.ex", web_dir("controllers/elm_controller.ex")},
      {:text, "templates/elm/index.html.eex", web_dir("templates/elm/index.html.eex")}
    ]

    Mix.shell.info("adding phoenix files 🕊 🔥")
    copy_files(templates)
  end

  defp update_time_created do
    [
      web_dir("views/elm_view.ex"),
      web_dir("controllers/elm_controller.ex")
    ]
    |> Enum.map(&File.touch!(&1))
  end

  defp web_dir(path) do
    Mix.Phoenix.context_app()
    |> Mix.Phoenix.web_path()
    |> Path.join(path)
  end

  defp copy_files(templates) do
    Mix.Phoenix.copy_from(
      [:phoenix_elm_scaffold], @src, [app_name: app_module_name()], templates
    )
  end

  defp copy_elm_files do
    files = [
      "assets/elm/Main.elm",
      "assets/elm/State.elm",
      "assets/elm/View.elm",
      "assets/elm/Types.elm",
      "assets/js/elm-embed.js",
      "assets/elm-package.json",
      "test/elm/Main.elm",
      "test/elm/Sample.elm",
      "test/elm/elm-package.json"
    ]
    |> Enum.map(&text_file/1)

    Mix.shell.info("adding elm files 🌳")
    copy_files(files)
  end

  defp text_file(path) do
    {:text, path, path}
  end

  defp app_module_name do
    Mix.Phoenix.context_app()
    |> Atom.to_string
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join("")
  end

  defp install_node_modules do
    deps = [
      "elm"
    ]

    dev_deps = [
      "elm-brunch",
      "elm-test"
    ]

    change_dir = "cd assets"
    pre_install = "npm install"
    node_install_deps = "npm install -S " <> Enum.join(deps, " ")
    node_install_dev_deps = "npm install -D " <> Enum.join(dev_deps, " ")

    # TODO: make these not depend on a global version of elm
    elm_install = "elm-package install -y"
    elm_compile = "elm-make elm/Main.elm --output=js/elm.js"

    all_cmds = [
      change_dir,
      pre_install,
      node_install_deps,
      node_install_dev_deps,
      elm_install,
      elm_compile
    ]

    cmd = Enum.join(all_cmds, " && ")

    Mix.shell.info("installing node modules for elm-app ⬇️")
    Mix.shell.info(cmd)
    status = Mix.shell.cmd(cmd, stderr_to_stdout: true)
    case status do
      0 -> :ok
      _ -> raise "Error installing node modules: #{status}"
    end
  end
end
