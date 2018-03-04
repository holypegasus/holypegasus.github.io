import Html exposing (Html, button, div, br, h1, h2)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Date



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL
type alias Model = 
  { time : Time
  , paused : Bool
  }


init : (Model, Cmd Msg)
init =
  (Model 0 False, Cmd.none)



-- UPDATE
type Msg
  = Tick Time
  | Toggle


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (Model newTime model.paused, Cmd.none)

    Toggle ->
      (Model model.time (not model.paused), Cmd.none)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  if model.paused then
    Sub.none
  else
    Time.every second Tick



-- VIEW
view : Model -> Html Msg
view model =
  let
    fractMinute = getFractTime model.time Time.inMinutes 1
    angleMinute = getAngle fractMinute
    (secondHandX, secondHandY) = getHandCoords angleMinute 50 40

    fractHour = getFractTime model.time Time.inHours 1
    angleHour = getAngle fractHour
    (minuteHandX, minuteHandY) = getHandCoords angleHour 50 30

  in
    div [] 
      [ svg [ viewBox "0 0 100 100", width "300px" ]
        [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
        , line [ x1 "50", y1 "50", x2 secondHandX, y2 secondHandY, stroke "#023963" ] []
        , line [ x1 "50", y1 "50", x2 minuteHandX, y2 minuteHandY, stroke "#023963" ] []
        ]
        , br [] []
        , button [ onClick Toggle ] [ model |> showToggle |> text ]
        , h1 [] [ model.time |> Date.fromTime |> toString |> text ]
        , Html.text "bon voyage!"
      ]


getFractTime : Time -> (Time -> Float) -> Float -> Float
getFractTime time normalize span =
  (time |> normalize) / span


getAngle : Float -> Float
getAngle fractTime =
  (turns fractTime) - pi/2


getHandCoords : Float -> Float -> Float -> (String, String)
getHandCoords angle center length =
  let
    handX =
      toString (center + length * cos angle)
    handY =
      toString (center + length * sin angle)
  in
    (handX, handY)


showToggle : Model -> String
showToggle model =
  if model.paused then
    "Start clock"
  else
    "Pause clock"


