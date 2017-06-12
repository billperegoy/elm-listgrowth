module Update exposing (update)

import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPaletteDrawerStatus paletteDrawerStatus ->
            { model | paletteDrawerStatus = paletteDrawerStatus } ! []

        SelectField fieldName selectStatus ->
            { model
                | contactFields =
                    transformOneField updateSelectStatus fieldName selectStatus model.contactFields
            }
                ! []

        SetRequired fieldName requiredValue ->
            { model
                | contactFields =
                    transformOneField updateFieldRequirement fieldName requiredValue model.contactFields
            }
                ! []


transformOneField : (FieldName -> Bool -> Field -> Field) -> FieldName -> Bool -> List Field -> List Field
transformOneField updateFunction fieldName updateValue fields =
    fields
        |> List.map (\field -> updateFunction fieldName updateValue field)


updateFieldRequirement : FieldName -> Bool -> Field -> Field
updateFieldRequirement fieldName selectStatus field =
    if field.fieldName == fieldName then
        setSelectionStatus fieldName selectStatus (Selected Required) (Selected Optional) field
    else
        field


updateSelectStatus : FieldName -> Bool -> Field -> Field
updateSelectStatus fieldName selectStatus field =
    if field.fieldName == fieldName then
        setSelectionStatus fieldName selectStatus (Selected Optional) Unselected field
    else
        field


setSelectionStatus : FieldName -> Bool -> FieldSelection -> FieldSelection -> Field -> Field
setSelectionStatus fieldName selectStatus trueValue falseValue field =
    if selectStatus then
        { field | selectionStatus = trueValue }
    else
        { field | selectionStatus = falseValue }
