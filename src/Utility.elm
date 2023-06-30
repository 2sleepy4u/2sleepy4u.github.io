module Utility exposing (..)

import Types exposing (..)

import Element as E
import Http
import Json.Decode exposing (..)

colorBlack = E.rgb255 33 33 33
colorWhiteBg = E.rgba255 207 204 198 0.6
colorWhiteText = E.rgba255 207 204 198 1
colorRed = E.rgba255 255 0 0 0.7


handleErrors : Model -> ( Model, Cmd Msg ) 
handleErrors model =
    ( { model | theme = Error, poem = { title = "Error", body = "Le parole si sono perse da qualche parte in Internet..." }}, Cmd.none)


fetchPoemlist : Cmd Msg
fetchPoemlist = 
    Http.get
        { url = "https://raw.githubusercontent.com/2sleepy4u/2sleepy4u.github.io/main/list.json"
        , expect = Http.expectJson GotPoemList poemListDecoder
        }

poemListDecoder : Decoder PoemList
poemListDecoder =
    Json.Decode.array 
        ( Json.Decode.map2 PoemData
            (field "id" string)
            (field "title" string)
        )


fetchPoem : String -> Cmd Msg
fetchPoem poemId = 
    Http.get 
        { url = "https://raw.githubusercontent.com/2sleepy4u/2sleepy4u.github.io/main/poems/" ++ poemId ++ ".txt"
        , expect = Http.expectString GotPoem
        }


