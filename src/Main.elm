module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Utils


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type PaletteDrawerStatus
    = Closed
    | TitleDrawerActive
    | DescriptionDrawerActive
    | ContactFieldsDrawerActive
    | EmailListsDrawerActive
    | ButtonDrawerActive
    | BackgroundDrawerActive


type FieldType
    = Email
    | FirstName
    | LastName
    | PhoneNumber
    | Country
    | Street
    | City
    | State
    | PostalCode
    | Company
    | JobTitle
    | Birthday
    | Anniversary


type FieldSelection
    = Unselected
    | Selected FieldRequirement


type FieldRequirement
    = Required
    | Optional


type alias Field =
    { fieldType : FieldType
    , selectionStatus : FieldSelection
    }


type alias Color =
    String


type alias EmailList =
    { name : String
    , selected : Bool
    }



-- Model


type alias Model =
    { paletteDrawerStatus : PaletteDrawerStatus
    , formName : String
    , titleText : String
    , titleColor : Color
    , descriptionText : String
    , descriptionColor : Color
    , contactFields : List Field
    , emailLists : List EmailList
    , buttonText : String
    , buttonTextColor : Color
    , buttonBackgroundColor : Color
    , backgroundColor : Color
    }


initContactFields : List Field
initContactFields =
    [ Field Email (Selected Required)
    , Field FirstName Unselected
    , Field LastName Unselected
    , Field PhoneNumber Unselected
    , Field Country Unselected
    , Field Street Unselected
    , Field City Unselected
    , Field State Unselected
    , Field PostalCode Unselected
    , Field Company Unselected
    , Field JobTitle Unselected
    , Field Birthday Unselected
    , Field Anniversary Unselected
    ]


init : ( Model, Cmd Msg )
init =
    { paletteDrawerStatus = Closed
    , formName = "default"
    , titleText = "default"
    , titleColor = "#ffffff"
    , descriptionText = "default"
    , descriptionColor = "#ffffff"
    , contactFields = initContactFields
    , emailLists = []
    , buttonText = "Submit"
    , buttonTextColor = "#ffffff"
    , buttonBackgroundColor = "#ffffff"
    , backgroundColor = "#ffffff"
    }
        ! []



-- Update


type Msg
    = SetPaletteDrawerStatus PaletteDrawerStatus


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPaletteDrawerStatus paletteDrawerStatus ->
            { model | paletteDrawerStatus = paletteDrawerStatus } ! []



-- View


view : Model -> Html Msg
view model =
    h1 []
        [ text "Hello " ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
