module Model exposing (..)


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


type Msg
    = SetPaletteDrawerStatus PaletteDrawerStatus
    | SelectField FieldName Bool
    | SetRequired FieldName Bool
