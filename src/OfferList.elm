module OfferList exposing (main)

import Browser
import Html exposing (Html, div, text)


type alias Model =
    { offers : List OfferCard
    }


type alias CashOfferCardDetails =
    { offerType : OfferType, offer : Float }


type alias FinanceOfferCardDetails =
    { offerType : OfferType, financeType : FinanceType, financeView : FinanceView, financeOffer : Float }


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


initialOfferCards : List OfferCard
initialOfferCards =
    [ Cash { offerType = HotDeal, offer = 100.0 }, Finance { offerType = NonHotDeal, financeType = PcpFinance, financeView = Monthly, financeOffer = 10000 }, Finance { offerType = NonHotDeal, financeType = PcpFinance, financeView = Lump, financeOffer = 10000 } ]


type alias Flags =
    {}


type Msg
    = NoOp


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { offers = initialOfferCards }
    in
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [] <| List.map offerCardView model.offers


offerCardView : OfferCard -> Html Msg
offerCardView offerCard =
    case offerCard of
        Cash offerDetails ->
            cashOfferCardView offerDetails

        Finance offerDetails ->
            financeOfferCardView offerDetails


cashOfferCardView : CashOfferCardDetails -> Html Msg
cashOfferCardView offerDetails =
    div [] [ text <| String.fromFloat offerDetails.offer ]


financeOfferCardView : FinanceOfferCardDetails -> Html Msg
financeOfferCardView offerDetails =
    case offerDetails.financeView of
        Monthly ->
            div [] [ text <| String.fromFloat <| offerDetails.financeOffer / 12 ]

        Lump ->
            div [] [ text <| String.fromFloat <| offerDetails.financeOffer ]


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
