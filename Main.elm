module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


-- TYPES


type DisplayState
    = DisplayNone
    | DisplayArtist Artist
    | DisplayComments Song


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
    , comment : Comment
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


artist1 : Artist
artist1 =
    { name = "Cordel"
    , label = "Not Wrong"
    , age = 26
    , instruments = [ initialGuitar, initialPiano ]
    }


artist2 : Artist
artist2 =
    { name = "Kikep"
    , label = "Not Wrong"
    , age = 26
    , instruments = [ initialPiano ]
    }


initialSongs : List Song
initialSongs =
    [ { name = "End of it All"
      , description = "Thundercat Rip"
      , key = "A Major"
      , tempo = 120
      , artist = artist1
      , comments = [ { user = "Cordel", content = "This song my favorite" } ]
      }
    , { name = "Something's Gotta Give"
      , description = "Holy Holy"
      , key = "D Minor"
      , tempo = 88
      , artist = artist2
      , comments = []
      }
    ]


initialComment : Comment
initialComment =
    Comment "" ""


initialModel : Model
initialModel =
    { songs = initialSongs
    , displayState = DisplayNone
    , comment = initialComment
    }



-- UPDATE


type Msg
    = DoNothing
    | ShowArtistDetails DisplayState
    | ShowCommentDetails DisplayState
    | SetCommentUsername String
    | SetCommentContent String
    | SaveComment Song
    | CancelComment


update : Msg -> Model -> Model
update msg model =
    case msg of
        DoNothing ->
            model

        SetCommentUsername value ->
            let
                updatedComment =
                    Comment value model.comment.content
            in
                ({ model | comment = updatedComment })

        SetCommentContent value ->
            let
                updatedComment =
                    Comment model.comment.user value
            in
                ({ model | comment = updatedComment })

        ShowArtistDetails artistState ->
            ({ model | displayState = artistState })

        ShowCommentDetails commentState ->
            ({ model | displayState = commentState })

        CancelComment ->
            ({ model | comment = initialComment })

        SaveComment song ->
            let
                commentedSong =
                    addCommentToSong model song

                updatedSongList =
                    List.map (replaceMatching commentedSong) model.songs
            in
                ({ model | songs = updatedSongList, displayState = (DisplayComments commentedSong), comment = initialComment })


replaceMatching : Song -> Song -> Song
replaceMatching updatedSong songFromList =
    if updatedSong.name == songFromList.name then
        updatedSong
    else
        songFromList


addCommentToSong : Model -> Song -> Song
addCommentToSong model song =
    ({ song | comments = (song.comments ++ (newCommentList model)) })


newCommentList : Model -> List Comment
newCommentList model =
    List.singleton (Comment model.comment.user model.comment.content)



-- clearCommentEntries : Model -> Model
-- clearCommentEntries model =
--     ({ model | newCommentContent = "", newCommentUser = "" })
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

            DisplayComments song ->
                div []
                    [ header ("Comments for " ++ song.name)
                    , table
                        [ class "table" ]
                        [ thead []
                            [ tr []
                                [ th [] [ text "Username" ]
                                , th [] [ text "Comment" ]
                                ]
                            ]
                        , tbody [] (viewComments song.comments)
                        ]
                    , viewAddComment model song
                    ]

            DisplayNone ->
                text ""


primaryButton : Msg -> String -> Html Msg
primaryButton msg name =
    button [ class "btn btn-primary", onClick msg ] [ text name ]


viewAddComment : Model -> Song -> Html Msg
viewAddComment model song =
    div [ class "form-group" ]
        [ input
            [ type_ "text"
            , placeholder "Username"
            , value model.comment.user
            , autofocus True
            , onInput SetCommentUsername
            ]
            []
        , br [] []
        , br [] []
        , textarea
            [ placeholder "Comment"
            , value model.comment.content
            , onInput SetCommentContent
            ]
            []
        , br [] []
        , br [] []
        , primaryButton (SaveComment song) "Save"
        , br [] []
        , br [] []
        , primaryButton CancelComment "Cancel"
        ]


instruments : List Instrument -> String
instruments instruments =
    String.join ", " (List.map .name instruments)


viewComment : Comment -> Html Msg
viewComment comment =
    tr []
        [ td [] [ text comment.user ]
        , td [] [ text comment.content ]
        ]


viewComments : List Comment -> List (Html Msg)
viewComments comments =
    if comments == [] then
        [ text "Currently No Comments for this Song" ]
    else
        List.map viewComment comments


viewSong : Song -> Html Msg
viewSong song =
    tr []
        [ td [] [ a [ href "#", onClick (ShowCommentDetails (DisplayComments song)) ] [ text song.name ] ]
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
        , div [] [ text (toString (model)) ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , model = initialModel
        , update = update
        }
