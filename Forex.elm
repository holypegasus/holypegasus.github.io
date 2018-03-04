--import Date
import Dict exposing (Dict, get)
import Html exposing (Html, button, div, br, h1, h2, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
{-  keep data
-}
type alias Ccy =
  { name : String
  , rate : String
  , lastRefreshed : String
  }

type alias Model =
  --{ ccys : Dict String Ccy}
  { ccy : Ccy }

init : (Model, Cmd Msg)
init =
  ( Model (Ccy "CAD" "" "")
      --Dict.fromList
      --  [ ("CAD", Ccy "CAD" Dict.empty) 
      --  , ("EUR", Ccy "EUR" Dict.empty)]
  , Cmd.none
  )

-- UPDATE
{- data -> model
  1 click refres
  2 auto-refresh on interval
-}
type Msg
  = Refresh
  | CallAPI (Result Http.Error Ccy)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Refresh ->
      (model, updateModel model)

    CallAPI (Ok ccy) ->
      (Model ccy, Cmd.none)

    CallAPI (Err err) ->
      (model, Cmd.none)

--decode : Decode.Decoder Ccy
decode : Decode.Decoder Ccy
decode =
  Decode.map3 Ccy
    (Decode.at ["Realtime Currency Exchange Rate", "3. To_Currency Code"] Decode.string)
    (Decode.at ["Realtime Currency Exchange Rate", "5. Exchange Rate"] Decode.string)
    (Decode.at ["Realtime Currency Exchange Rate", "6. Last Refreshed"] Decode.string)

getInfo : String -> Cmd Msg
getInfo ccyName =
  let
    url = 
      "https://www.alphavantage.co/query?apikey=NO996F3K9CX1XLOQ&function=CURRENCY_EXCHANGE_RATE&from_currency=usd&to_currency=" ++ ccyName
  in
    Http.send CallAPI (Http.get url decode)

updateCcy : Ccy -> Cmd Msg
updateCcy ccy =
  getInfo ccy.name

updateModel : Model -> Cmd Msg
updateModel model =
  --Model List.map updateCcy model.ccys
  updateCcy model.ccy


-- SUBSCRIPTIONS
{- get data
  1 periodic API call
  2 subscribe ?
-}
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW
{- show forex mutual rates
  1 simple ino USD
  2 matrix
  3 map/graph
-}
view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ model.ccy |> toString |> text ]
    , button [ onClick Refresh ] [ "refresh" |> text ]
    ]

--renderCcy : Ccy -> String
--renderCcy ccy = ""
