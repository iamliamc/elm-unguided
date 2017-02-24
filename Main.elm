module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- import Html.Events exposing (onClick)
-- TYPES


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
    }


type alias Model =
    { songs : List Song
    }



-- SEED Model


initialGuitar : Instrument
initialGuitar =
    { name = "Guitar"
    , origin = "Japan"
    , age = 16
    }


initialPiano : Instrument
initialPiano =
    { name = "Rhodes"
    , origin = "USA"
    , age = 34
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
    }



-- UPDATE


type Msg
    = DoNothing


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model



-- VIEW


viewSong : Song -> Html Msg
viewSong song =
    tr []
        [ td [] [ text song.name ]
        , td [] [ text song.description ]
        , td [] [ text song.key ]
        , td [] [ text (toString song.tempo) ]
        , td [] [ text song.artist.name ]
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
                ]
            ]
        , tbody [] (List.map viewSong songs)
        ]


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ h2 [] [ text "Song Catalog!" ]
        , viewSongTable model.songs
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = initialModel
        , update = update
        }
