module Sample exposing (..)

import Test exposing (..)
import Expect


all : Test
all =
    describe "sample test"
        [ test "assert the truth" <|
            \() ->
                (1 + 1) |> Expect.equal 2
        ]
