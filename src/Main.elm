module Main exposing (..)

import Model exposing (..)
import View
import Update
import Subscriptions
import Html exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = Model.init
        , view = View.view
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        }
