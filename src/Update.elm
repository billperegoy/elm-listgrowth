module Update exposing (update)

import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPaletteDrawerStatus paletteDrawerStatus ->
            { model | paletteDrawerStatus = paletteDrawerStatus } ! []

        SetSelected fieldName True ->
            { model
                | contactFields =
                    transformOneField fieldName (Selected Optional) model.contactFields
            }
                ! []

        SetSelected fieldName False ->
            { model
                | contactFields =
                    transformOneField fieldName Unselected model.contactFields
            }
                ! []

        SetRequired fieldName True ->
            { model
                | contactFields =
                    transformOneField fieldName (Selected Required) model.contactFields
            }
                ! []

        SetRequired fieldName False ->
            { model
                | contactFields =
                    transformOneField fieldName (Selected Optional) model.contactFields
            }
                ! []


transformOneField : FieldName -> FieldSelection -> List Field -> List Field
transformOneField fieldName value fields =
    fields
        |> List.map (\field -> conditionalFieldTransform fieldName value field)


conditionalFieldTransform : FieldName -> FieldSelection -> Field -> Field
conditionalFieldTransform fieldName value field =
    if field.fieldName == fieldName then
        { field | selectionStatus = value }
    else
        field
