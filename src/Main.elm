module Main exposing (..)

import Html
import Model exposing (..)
import View
import Update
import Subscriptions


main : Program Never Model Msg
main =
    Html.program
        { init = Model.init
        , view = View.view
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        }
