module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)


view : Model -> Html Msg
view model =
    div [ style styles ] [ text "your app goes here" ]


styles : List ( String, String )
styles =
    [ ( "text-align", "center" )
    , ( "color", "#0192C8" )
    , ( "margin-top", "2em" )
    , ( "font-family", "helvetica" )
    ]
