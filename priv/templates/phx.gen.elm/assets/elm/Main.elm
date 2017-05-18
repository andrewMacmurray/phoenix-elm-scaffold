module Main exposing (..)

import Html exposing (program)
import Model exposing (Model, Msg)
import Update exposing (init, subscriptions, update)
import View exposing (view)


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
