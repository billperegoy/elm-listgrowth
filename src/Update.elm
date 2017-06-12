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
                    transformOneField fieldName selectStatus (Selected Optional) Unselected model.contactFields
            }
                ! []

        SetRequired fieldName requiredValue ->
            { model
                | contactFields =
                    transformOneField fieldName requiredValue (Selected Required) (Selected Optional) model.contactFields
            }
                ! []


transformOneField : FieldName -> Bool -> FieldSelection -> FieldSelection -> List Field -> List Field
transformOneField fieldName updateValue trueValue falseValue fields =
    fields
        |> List.map (\field -> conditionalFieldTransform fieldName updateValue trueValue falseValue field)


conditionalFieldTransform : FieldName -> Bool -> FieldSelection -> FieldSelection -> Field -> Field
conditionalFieldTransform fieldName selectStatus trueValue falseValue field =
    if field.fieldName == fieldName then
        setSelectionStatus fieldName selectStatus trueValue falseValue field
    else
        field


setSelectionStatus : FieldName -> Bool -> FieldSelection -> FieldSelection -> Field -> Field
setSelectionStatus fieldName selectStatus trueValue falseValue field =
    if selectStatus then
        { field | selectionStatus = trueValue }
    else
        { field | selectionStatus = falseValue }
