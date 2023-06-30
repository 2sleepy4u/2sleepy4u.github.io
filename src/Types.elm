module Types exposing (..)

import Http
import Array exposing (Array)

type alias Flags = {}

type alias Model =
    { theme: Theme
    , poem: Poem
    }

type Msg 
    = NoOp
    | ChangeTheme
    | GotPoem (Result Http.Error String)
    | GotPoemList (Result Http.Error PoemList)
    | GetRandomPoem PoemList Int

type Theme
    = Light
    | Dark
    | Error

type alias Poem = {
    title: String,
    body: String
    }

type alias PoemData = 
    { id: String
    , title: String
    }

type alias PoemList = Array PoemData
