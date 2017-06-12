module Update exposing (update)

import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPaletteDrawerStatus paletteDrawerStatus ->
            { model | paletteDrawerStatus = paletteDrawerStatus } ! []

        SetSelected fieldName True ->
            { model | contactFields = mapOnFieldMatch fieldName (Selected Optional) model.contactFields } ! []

        SetSelected fieldName False ->
            { model | contactFields = mapOnFieldMatch fieldName Unselected model.contactFields } ! []

        SetRequired fieldName True ->
            { model | contactFields = mapOnFieldMatch fieldName (Selected Required) model.contactFields } ! []

        SetRequired fieldName False ->
            { model | contactFields = mapOnFieldMatch fieldName (Selected Optional) model.contactFields } ! []


mapOnFieldMatch : FieldName -> FieldSelection -> List Field -> List Field
mapOnFieldMatch fieldName value fields =
    List.map (updateOnMatch fieldName value) fields


updateOnMatch : FieldName -> FieldSelection -> Field -> Field
updateOnMatch fieldName value field =
    if field.fieldName == fieldName then
        { field | selectionStatus = value }
    else
        field
