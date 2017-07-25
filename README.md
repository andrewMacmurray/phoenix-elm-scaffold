# Phoenix Elm Scaffold

Mix Task to generate an elm app plus the necessary scaffolding for a Phoenix 1.3 app

## Installation

Install the package by adding to `deps` and run `mix deps.get`

```elixir
def deps do
  [{:elm_scaffold, "~> 0.1.0"}]
end
```

## Usage

To generate the scaffolding for an elm app, make sure you have [elm](https://guide.elm-lang.org/install.html) installed and run:

```sh
> mix phx.gen.elm
```

this will generate the following files and run install commands:

```
├── assets
│   ├── elm
│   │   ├── Main.elm
│   │   ├── Model.elm
│   │   ├── Update.elm
│   │   └── View.elm
│   ├── elm-package.json
│   ├── js
│   │   └── elm-embed.js
├── lib
│   └── your_app
│       └── web
│           ├── controllers
│           │   ├── elm_controller.ex
│           ├── templates
│           │   ├── elm
│           │   │   └── index.html.eex
│           └── views
│               └── elm_view.ex
└── test
    └── elm
        ├── Main.elm
        ├── Sample.elm
        └── elm-package.json
```


after the command has finished follow the next steps:

1: add the following to the `plugins` section of your `brunch-config.js`

```js
elmBrunch: {
  mainModules: ['elm/Main.elm'],
  outputFile: 'elm.js',
  outputFolder: '../assets/js',
  makeParameters: ['--debug'] // optional debugger for development
}
```

2: add `elm` to the `watched` array in your `brunch-config.js`
   You may also want to add `/elm\\.js/` to the babel ignore pattern to speed up compilation

```js
babel: {
  ignore: [/vendor/, /elm\.js/]
}
```


3: in your `app.js` file add the following

```js
import ElmApp from './elm.js'
import elmEmbed from './elm-embed.js'

elmEmbed.init(ElmApp)
```


4: and finally in your `router.ex` file add

```elixir
get "/path-to-elm-app", ElmController, :index
```
