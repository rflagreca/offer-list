module OfferList exposing (main)

import Browser
import Html exposing (Html, div)


type alias Model =
    { offers : List OfferCard
    }


type alias CashOfferCardDetails =
    { offerType : OfferType, offer : Float }


type alias FinanceOfferCardDetails =
    { offerType : OfferType, financeType : FinanceType, financeView : FinanceView }


type FinanceType
    = PcpFinance
    | CodeweaversFinance


type FinanceView
    = Monthly
    | Lump


type OfferType
    = HotDeal
    | NonHotDeal


type OfferCard
    = Cash CashOfferCardDetails
    | Finance FinanceOfferCardDetails


initialOfferCard : List OfferCard
initialOfferCard =
    [ Cash { offerType = HotDeal, offer = 100.0 } ]


type alias Flags =
    {}


type Msg
    = NoOp


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { offers = initialOfferCard }
    in
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [] <| List.map offerCardView model.offers


offerCardView : OfferCard -> Html Msg
offerCardView offerCard =
    case offerCard of
        Cash offerDetails ->
            div [] []

        Finance offerDetails ->
            div [] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
