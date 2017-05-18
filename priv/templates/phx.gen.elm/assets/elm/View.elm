module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div [ style styles ] [ text "your idea goes here" ]


styles : List ( String, String )
styles =
    [ ( "text-align", "center" )
    , ( "color", "#0192C8" )
    , ( "margin-top", "2em" )
    , ( "font-family", "helvetica" )
    ]
