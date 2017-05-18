defmodule Mix.Tasks.Phx.Gen.Elm do
  use Mix.Task
  import Mix.Generator

  @shortdoc "Generates an elm app with all the necessary scaffolding"

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

    1. add the following to the 'plugins' section of your brunch-config.js


        elmBrunch: {
          mainModules: ['elm/Main.elm'],
          outputFile: 'elm.js',
          outputFolder: '../assets/js',
          makeParameters: ['--debug']
        }

    2. add 'elm' to the 'watched' array in your brunch-config.js


    3. in your app.js file add the following


        import ElmApp from './elm.js'
        import elmEmbed from './elm-embed.js'

        elmEmbed.init(ElmApp)


    4. and finally in your 'router.ex' file add


        get "/", ElmController, :index


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
    web_path = Mix.Phoenix.web_prefix()
    Path.join(web_path, path)
  end

  defp copy_files(templates) do
    Mix.Phoenix.copy_from(
      [Mix.Phoenix.otp_app()], @src, "", [app_name: app_module_name()], templates
    )
  end

  defp copy_elm_files do
    files = [
      "assets/elm/Main.elm",
      "assets/elm/Update.elm",
      "assets/elm/View.elm",
      "assets/elm/Model.elm",
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
    Mix.Phoenix.otp_app()
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
    node_install_deps = "npm install -S " <> Enum.join(deps, " ")
    node_install_dev_deps = "npm install -D " <> Enum.join(dev_deps, " ")
    elm_install = "elm-package install -y"

    all_cmds = [
      change_dir,
      node_install_deps,
      node_install_dev_deps,
      elm_install
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
