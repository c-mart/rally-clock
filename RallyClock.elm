{-
   Three things:
   - GPS odometer (not doing tonight)
   -
-}


module Main exposing (..)

import Date
import Html exposing (Html, program)
import Time
import Element exposing (el)
import Element.Attributes as ElAttributes
import Style
import Style.Color as Color
import Style.Font as Font
import Color exposing (..)


main =
    program { init = init, view = view, update = update, subscriptions = subs }


type alias Model =
    Time.Time


view : Model -> Html Msg
view model =
    let
        date =
            Date.fromTime model

        hours =
            Date.hour date

        mins =
            Date.minute date

        secs =
            Date.second date

        millisecs =
            Date.millisecond date

        preciseSecs =
            (toFloat secs) + (toFloat millisecs / 1000)

        hundredthsOfMins =
            secsToHundredths preciseSecs

        timeText =
            (intToPadStr hours) ++ " : " ++ (intToPadStr mins) ++ " . " ++ (intToPadStr hundredthsOfMins)
    in
        Element.viewport stylesheet <|
            el Title
                [ ElAttributes.width (ElAttributes.percent 100), ElAttributes.height (ElAttributes.percent 99.9999), ElAttributes.verticalCenter ]
                (Element.text timeText)


secsToHundredths : Float -> Int
secsToHundredths secs =
    secs
        / 60
        * 100
        |> floor


intToPadStr : Int -> String
intToPadStr int =
    String.padLeft 2 '0' (toString int)


type Msg
    = Tick Time.Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( newTime, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( 0, Cmd.none )


subs : Model -> Sub Msg
subs model =
    Time.every (Time.minute / 500) Tick


type MyStyles
    = Title


stylesheet =
    Style.styleSheet
        [ Style.style Title
            [ Color.text yellow
            , Color.background black
            , Font.size 150
            , Font.center
              -- all units given as px
            ]
        ]
