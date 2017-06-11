module View exposing (view)

import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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
            toggleSwitch SetRequired field.fieldName isChecked


fieldDisplayText : Field -> String
fieldDisplayText field =
    if List.member field.selectionStatus [ Immutable, Selected Required ] then
        "*" ++ fieldNameString field.fieldName
    else
        fieldNameString field.fieldName


toggleSwitch : (FieldName -> Bool -> Msg) -> FieldName -> Bool -> Html Msg
toggleSwitch action fieldName isChecked =
    label [ class "switch" ]
        [ input [ onCheck (action fieldName), type_ "checkbox", checked isChecked ] []
        , div [ class "slider round" ] []
        ]


sidebarTableRow : Field -> Html Msg
sidebarTableRow field =
    let
        fieldElement =
            h4 [] [ text (fieldNameString field.fieldName) ]

        isChecked =
            field.selectionStatus /= Unselected

        selectCheckbox =
            if field.selectionStatus == Immutable then
                div [] []
            else
                toggleSwitch SelectField field.fieldName isChecked
    in
        tr []
            [ td [] [ selectCheckbox ]
            , td [] [ fieldElement ]
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
    tbody [] (fields |> List.map sidebarTableRow)


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
                        [ text (fieldDisplayText field) ]
                    , input [ class "form-control", id name, placeholder name ]
                        []
                    ]

            DateField ->
                div [ class "form-group" ]
                    [ label [ for name ]
                        [ text (fieldDisplayText field) ]
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
                        [ text (fieldDisplayText field) ]
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
