module Update exposing (update)

import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetPaletteDrawerStatus paletteDrawerStatus ->
            { model | paletteDrawerStatus = paletteDrawerStatus } ! []

        SetSelected fieldName True ->
            { model | contactFields = updateMatchingField fieldName (Selected Optional) model.contactFields } ! []

        SetSelected fieldName False ->
            { model | contactFields = updateMatchingField fieldName Unselected model.contactFields } ! []

        SetRequired fieldName True ->
            { model | contactFields = updateMatchingField fieldName (Selected Required) model.contactFields } ! []

        SetRequired fieldName False ->
            { model | contactFields = updateMatchingField fieldName (Selected Optional) model.contactFields } ! []


updateMatchingField : FieldName -> FieldSelection -> List Field -> List Field
updateMatchingField fieldName value fields =
    List.map (updateOnMatch fieldName value) fields


updateOnMatch : FieldName -> FieldSelection -> Field -> Field
updateOnMatch fieldName value field =
    if field.fieldName == fieldName then
        { field | selectionStatus = value }
    else
        field
