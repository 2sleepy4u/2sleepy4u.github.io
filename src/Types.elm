module Types exposing (..)

import Http

type alias Flags = {}

type alias Model =
    { theme: Theme
    , poem: Poem
    }

type Msg 
    = NoOp
    | ChangeTheme
    | GotPoem (Result Http.Error String)

type Theme
    = Light
    | Dark

type alias Poem = {
    title: String,
    body: String
    }

