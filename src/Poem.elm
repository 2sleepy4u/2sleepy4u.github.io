module Poem exposing (..)

import Types exposing (..)

import Element as E
import Element.Font as Font
import Element.Border as Border
import Element.Background as Background
import Html exposing (Html)
import List exposing (map)

createPoemRow : String -> E.Element msg
createPoemRow row =
    E.row [  ]
        [ E.text row]

poemTitle : String -> E.Element msg
poemTitle string = 
    E.row 
        [ E.centerX 
        , Font.size 30
        , Border.widthEach 
            { bottom = 1
            , left = 0
            , right = 0
            , top = 0
            }
        ]
        [ E.text string ]

poemBody : List String -> E.Element msg 
poemBody rows =
    E.column 
        [ E.height <| E.minimum 100 E.fill 
        , E.width <| E.px 300, E.scrollbarX
        ]
        <| List.map createPoemRow rows

poemBodySimple : String -> E.Element msg 
poemBodySimple string =
    E.paragraph 
        []
        [ E.text string ]



poem : Model -> E.Element msg 
poem model = 
    E.column 
            [ E.centerX
            , E.centerY
            , E.padding 10
            , E.spacing 30
            , Border.width 1
            , E.width <| E.px 390 
            , E.height <| E.px 650 
            ]
            [ poemTitle model.poem.title 
            , E.column 
                [ E.width <| E.fill, E.scrollbarX
                , E.height <| E.fill, E.scrollbarY
                ]
                [ E.text model.poem.body ]
            ]


