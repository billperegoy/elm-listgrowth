module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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


type FieldName
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
    = Immutable
    | Unselected
    | Selected FieldRequirement


type FieldRequirement
    = Required
    | Optional


type FieldType
    = StringField
    | DateField
    | DateWithoutYearField


type alias Field =
    { fieldName : FieldName
    , fieldType : FieldType
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
    , needsSaving : Bool
    }


initContactFields : List Field
initContactFields =
    [ Field Email StringField Immutable
    , Field FirstName StringField Unselected
    , Field LastName StringField Unselected
    , Field PhoneNumber StringField Unselected
    , Field Country StringField Unselected
    , Field Street StringField Unselected
    , Field City StringField Unselected
    , Field State StringField Unselected
    , Field PostalCode StringField Unselected
    , Field Company StringField Unselected
    , Field JobTitle StringField Unselected
    , Field Birthday DateWithoutYearField Unselected
    , Field Anniversary DateField Unselected
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
    , needsSaving = False
    }
        ! []



-- Update


type Msg
    = SetPaletteDrawerStatus PaletteDrawerStatus
    | SelectField FieldName Bool
    | SetRequired FieldName Bool


updateFieldRequirement : FieldName -> Bool -> Field -> Field
updateFieldRequirement fieldName selectStatus field =
    if field.fieldName == fieldName then
        if selectStatus then
            { field | selectionStatus = Selected Required }
        else
            { field | selectionStatus = Selected Optional }
    else
        field


updateSelectStatus : FieldName -> Bool -> Field -> Field
updateSelectStatus fieldName selectStatus field =
    if field.fieldName == fieldName then
        if selectStatus then
            { field | selectionStatus = Selected Optional }
        else
            { field | selectionStatus = Unselected }
    else
        field


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPaletteDrawerStatus paletteDrawerStatus ->
            { model | paletteDrawerStatus = paletteDrawerStatus } ! []

        SelectField fieldName selectStatus ->
            let
                contactFields =
                    model.contactFields
                        |> List.map (\field -> updateSelectStatus fieldName selectStatus field)
            in
                { model | contactFields = contactFields } ! []

        SetRequired fieldName requiredValue ->
            let
                contactFields =
                    model.contactFields
                        |> List.map (\field -> updateFieldRequirement fieldName requiredValue field)
            in
                { model | contactFields = contactFields } ! []



-- View


view : Model -> Html Msg
view model =
    div [ style [ ( "margin-top", "25px" ) ], class "container" ]
        [ div [ class "row" ]
            [ sidebar model.contactFields
            , spacer
            , mainBody model
            ]
        ]


spacer : Html Msg
spacer =
    div [ class "col-md-2" ] []


requiredBox : Field -> Html Msg
requiredBox field =
    let
        isChecked =
            field.selectionStatus == Selected Required
    in
        if List.member field.selectionStatus [ Unselected, Immutable ] then
            div [] []
        else
            label [ class "switch" ]
                [ input [ onCheck (SetRequired field.fieldName), type_ "checkbox", checked isChecked ] []
                , div [ class "slider round" ] []
                ]


requiredText : Field -> String
requiredText field =
    if List.member field.selectionStatus [ Immutable, Selected Required ] then
        "*"
    else
        ""


selectElement : Field -> Html Msg
selectElement field =
    let
        isChecked =
            not (field.selectionStatus == Unselected)

        selectCheckbox =
            if field.selectionStatus == Immutable then
                div [] []
            else
                label [ class "switch" ]
                    [ input [ onCheck (SelectField field.fieldName), type_ "checkbox", checked isChecked ] []
                    , div [ class "slider round" ] []
                    ]
    in
        tr []
            [ td [] [ selectCheckbox ]
            , td [] [ h4 [] [ text (fieldNameString field.fieldName) ] ]
            , td [] [ (requiredBox field) ]
            ]


sidebarTableHeader : Html Msg
sidebarTableHeader =
    thead []
        [ tr [ class "active" ]
            [ th [] [ h4 [] [ text "select?" ] ]
            , th [] [ h4 [] [ text "field name" ] ]
            , th [] [ h4 [] [ text "required?" ] ]
            ]
        ]


sidebarTableBody : List Field -> Html Msg
sidebarTableBody fields =
    tbody []
        (fields
            |> List.map selectElement
        )


sidebar : List Field -> Html Msg
sidebar fields =
    div [ class "col-md-2" ]
        [ table [ class "table" ]
            [ sidebarTableHeader
            , sidebarTableBody fields
            ]
        ]


fieldDisplay : Field -> Html Msg
fieldDisplay field =
    let
        name =
            fieldNameString field.fieldName
    in
        case field.fieldType of
            StringField ->
                div [ class "form-group" ]
                    [ label [ for name ]
                        [ text (requiredText field ++ name) ]
                    , input [ class "form-control", id name, placeholder name ]
                        []
                    ]

            DateField ->
                div [ class "form-group" ]
                    [ label [ for name ]
                        [ text (requiredText field ++ name) ]
                    , input [ class "form-control", id name, placeholder "month" ]
                        []
                    , input [ class "form-control", id name, placeholder "day" ]
                        []
                    , input [ class "form-control", id name, placeholder "year" ]
                        []
                    ]

            DateWithoutYearField ->
                div [ class "form-group" ]
                    [ label [ for name ]
                        [ text (requiredText field ++ name) ]
                    , input [ class "form-control", id name, placeholder "month" ]
                        []
                    , input [ class "form-control", id name, placeholder "day" ]
                        []
                    ]


mainBody : Model -> Html Msg
mainBody model =
    div [ class "col-md-4" ]
        [ Html.form []
            (model.contactFields
                |> List.filter (\field -> field.selectionStatus /= Unselected)
                |> List.map fieldDisplay
            )
        ]


fieldNameString : FieldName -> String
fieldNameString name =
    case name of
        Email ->
            "email"

        FirstName ->
            "first name"

        LastName ->
            "last name"

        PhoneNumber ->
            "phone"

        Country ->
            "country"

        Street ->
            "street"

        City ->
            "city"

        State ->
            "state"

        PostalCode ->
            "postal code"

        Company ->
            "company"

        JobTitle ->
            "job title"

        Birthday ->
            "birthday"

        Anniversary ->
            "anniversary"



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
