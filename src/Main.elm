module Main exposing (..)

import Poem exposing (..)
import Types exposing (..)
import Utility exposing (..)

import Browser
import Element as E
import Element.Font as Font
import Element.Background as Background
import Element.Events as Events
import Html exposing (Html)
import List exposing (map)
import Random
import Array exposing (Array)
import Html exposing (wbr)
import Platform.Cmd as Cmd

container: Model -> Html Msg 
container model =
    E.layout [ Events.onClick ChangeTheme ]
        <| E.column 
            [ E.height <| E.fill
            , E.width <| E.fill
            , Font.color 
                <| if model.theme == Error then colorRed
                    else if model.theme == Light then E.rgba255 0 0 0 1
                    else colorWhiteText
            , Background.color 
                <| if model.theme == Light then colorWhiteBg 
                    else colorBlack
            ]
        [ poem model ]

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


initialModel : Model
initialModel =
    { theme = Dark
    , poem = {
        title = "Etherny",
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
    , body = [ container model ]     
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model  , Cmd.none )
        GotPoem result -> 
            case result of 
                Ok poem ->
                    ({ model | poem = { title = model.poem.title, body = poem } }, Cmd.none )
                Err _ ->
                    handleErrors model
        GetRandomPoem poemList index ->
            case ( Array.get index poemList ) of
                Just poem ->
                    ( { model | poem = { title = poem.title, body = model.poem.body } }, fetchPoem poem.id )
                Nothing ->
                    handleErrors model
        GotPoemList result ->
            case result of 
                Ok poemList ->
                    ( model, Random.generate 
                        ( GetRandomPoem poemList ) 
                        ( Random.int 0 <| ( Array.length poemList) - 1 ) )
                Err _ ->
                    handleErrors model
        ChangeTheme ->
            case model.theme of 
                Light -> 
                    ( { model | theme = Dark }, Cmd.none)
                Dark -> 
                    ( { model | theme = Light }, Cmd.none)
                Error ->
                    ( { model | theme = Dark }, Cmd.none)

