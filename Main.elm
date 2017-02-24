module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- TYPES


type DisplayState
    = DisplayNone
    | DisplayArtist Artist
    | DisplayComments (List Comment)


type alias Comment =
    { user : String
    , content : String
    }


type alias Song =
    { name : String
    , description : String
    , key : String
    , tempo : Int
    , artist : Artist
    , comments : List Comment
    }


type alias Artist =
    { name : String
    , label : String
    , age : Int
    , instruments : List Instrument
    }


type alias Instrument =
    { name : String
    , origin : String
    , age : Int
    , picture : String
    }


type alias Model =
    { songs : List Song
    , displayState : DisplayState
    }



-- SEED Model


initialGuitar : Instrument
initialGuitar =
    { name = "Guitar"
    , origin = "Japan"
    , age = 16
    , picture = "./imgs/strat.jpg"
    }


initialPiano : Instrument
initialPiano =
    { name = "Rhodes"
    , origin = "USA"
    , age = 34
    , picture = ".imgs/rhodes.jpg"
    }


initialArtist : Artist
initialArtist =
    { name = "Cordel"
    , label = "Not Wrong"
    , age = 26
    , instruments = [ initialGuitar, initialPiano ]
    }


initialSongs : List Song
initialSongs =
    [ { name = "End of it All"
      , description = "Thundercat Rip"
      , key = "A Major"
      , tempo = 120
      , artist = initialArtist
      , comments = []
      }
    , { name = "Something's Gotta Give"
      , description = "Holy Holy"
      , key = "D Minor"
      , tempo = 88
      , artist = initialArtist
      , comments = []
      }
    ]


initialModel : Model
initialModel =
    { songs = initialSongs
    , displayState = DisplayNone
    }



-- UPDATE


type Msg
    = DoNothing
    | ShowArtistDetails DisplayState


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model

        ShowArtistDetails artistState ->
            ({ model | displayState = artistState })



-- VIEW


viewDetails : Model -> Html Msg
viewDetails model =
    let
        header displayType =
            h3 [] [ text displayType ]
    in
        case model.displayState of
            DisplayArtist artist ->
                div []
                    [ header "Artist Information:"
                    , dl [ class "dl-horizontal" ]
                        [ dt [] [ text "Name" ]
                        , dd [] [ text artist.name ]
                        , dt [] [ text "Label" ]
                        , dd [] [ text artist.label ]
                        , dt [] [ text "Age" ]
                        , dd [] [ text (toString artist.age) ]
                        , dt [] [ text "Instruments" ]
                        , dd [] [ text (instruments artist.instruments) ]
                        ]
                    ]

            DisplayComments comments ->
                div [] []

            DisplayNone ->
                text ""


instruments : List Instrument -> String
instruments instruments =
    String.join ", " (List.map .name instruments)


viewSong : Song -> Html Msg
viewSong song =
    tr []
        [ td [] [ text song.name ]
        , td [] [ text song.description ]
        , td [] [ text song.key ]
        , td [] [ text (toString song.tempo) ]
        , td [] [ text song.artist.name ]
        , td [] [ button [ class "btn btn-primary", onClick (ShowArtistDetails (DisplayArtist song.artist)) ] [ text "Details" ] ]
        ]


viewSongTable : List Song -> Html Msg
viewSongTable songs =
    table [ class "table table-striped" ]
        [ thead []
            [ tr []
                [ th [] [ text "Title" ]
                , th [] [ text "Description" ]
                , th [] [ text "Key" ]
                , th [] [ text "Tempo" ]
                , th [] [ text "Artist" ]
                , th [] [ text "Show Artist Details" ]
                ]
            ]
        , tbody [] (List.map viewSong songs)
        ]


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ h2 [] [ text "Song Catalog!" ]
        , viewSongTable model.songs
        , viewDetails model
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = initialModel
        , update = update
        }
