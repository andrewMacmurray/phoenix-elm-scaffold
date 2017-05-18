port module Main exposing (..)

import Json.Encode exposing (Value)
import Sample
import Test exposing (..)
import Test.Runner.Node exposing (TestProgram, run)


allTests : Test
allTests =
    describe "all tests"
        [ Sample.all
        ]


main : TestProgram
main =
    run emit allTests


port emit : ( String, Value ) -> Cmd msg
