module Main exposing (..)

import Poem exposing (..)
import Types exposing (..)

import Browser
import Element as E
import Element.Font as Font
import Element.Border as Border
import Element.Background as Background
import Element.Events as Events
import Html exposing (Html)
import List exposing (map)
import Http
import List exposing (map2)
import Json.Decode exposing (..)
import Random
import Array exposing (Array)
import Html exposing (wbr)

colorBlack = E.rgb255 33 33 33
colorWhiteBg = E.rgba255 207 204 198 0.6
colorWhiteText = E.rgba255 207 204 198 1

container: Model -> Html Msg 
container model =
    E.layout [ Events.onClick ChangeTheme ]
        <| E.column 
            [ E.height <| E.fill
            , E.width <| E.fill
            , Font.color 
                <| if model.theme == Light then E.rgba255 0 0 0 1
                    else colorWhiteText
            , Background.color 
                <| if model.theme == Dark then colorBlack
                    else colorWhiteBg
            ]
        [ poem model
        ]

fetchPoemlist : Cmd Msg
fetchPoemlist = 
    Http.get
        { url = "https://raw.githubusercontent.com/2sleepy4u/2sleepy4u.github.io/main/poems/list.json"
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

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



initialModel : Model
initialModel =
    { theme = Dark
    , poem = {
        title = "Internet",
        body = "Loading..."
        }
    }

init : Flags -> ( Model, Cmd Msg )
init _ =
    ( initialModel, fetchPoemlist )


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


view : Model -> Browser.Document Msg
view model =
    { title = "Example"
    , body =
        [ container model 
        ]     
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- case Debug.log "msg" msg of
    case msg of
        NoOp ->
            ( model  , Cmd.none )
        GotPoem result -> 
            case result of 
                Ok poem ->
                    ({ model | poem = { title = model.poem.title, body = poem } }, Cmd.none )
                Err _ ->
                    ( model, Cmd.none )
        GetRandomPoem poemList index ->
            case ( Array.get index poemList ) of
                Just poem ->
                    ( { model | poem = { title = poem.title, body = model.poem.body } }, fetchPoem poem.id )
                Nothing ->
                    ( model, Cmd.none )
        GotPoemList result ->
            case result of 
                Ok poemList ->
                    ( model, Random.generate ( GetRandomPoem poemList ) ( Random.int 1 6 ) )
                Err _ ->
                    ( model, Cmd.none)
        ChangeTheme ->
            case model.theme of 
                Light -> 
                    ( { model | theme = Dark }, Cmd.none)
                Dark -> 
                    ( { model | theme = Light }, Cmd.none)

