module OfferList exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type alias Model =
    { offers : List OfferCard
    , make : String
    , model : String
    , state : OfferListState
    }


type alias CashOfferCardDetails =
    { offer : Float }


type alias FinanceOfferCardDetails =
    { financeType : FinanceType, financeView : FinanceView, financeOffer : Float }


type alias GenericOfferCardDetails =
    { offerType : OfferType }


type OfferListState
    = WaitingForOffers
    | OffersReceived
    | OffersExpired


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
    = Cash GenericOfferCardDetails CashOfferCardDetails
    | Finance GenericOfferCardDetails FinanceOfferCardDetails


initialOfferCards : List OfferCard
initialOfferCards =
    [ Cash { offerType = HotDeal } { offer = 100.0 }, Finance { offerType = HotDeal } { financeType = PcpFinance, financeView = Monthly, financeOffer = 10000 }, Finance { offerType = NonHotDeal } { financeType = PcpFinance, financeView = Lump, financeOffer = 10000 } ]


type alias Flags =
    {}


type Msg
    = NoOp
    | ToggleState


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { offers = initialOfferCards, state = OffersReceived, make = "Audi", model = "A4" }
    in
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        offersView =
            case model.state of
                WaitingForOffers ->
                    div [] [ text "Waiting for your offers" ]

                OffersReceived ->
                    div [] <| List.map offerCardView model.offers

                OffersExpired ->
                    div [] [ text "Your offers have expired" ]
    in
    div [] [ offersView, stateToggleBtn ]


stateToggleBtn : Html Msg
stateToggleBtn =
    div [] [ button [ onClick ToggleState ] [ text "Toggle State" ] ]


offerCardView : OfferCard -> Html Msg
offerCardView offerCard =
    let
        concreteOfferCard =
            case offerCard of
                Cash genericOfferDetails offerDetails ->
                    ( genericOfferCardView genericOfferDetails, cashOfferCardView offerDetails )

                Finance genericOfferDetails offerDetails ->
                    ( genericOfferCardView genericOfferDetails, financeOfferCardView offerDetails )
    in
    div [] [ Tuple.first concreteOfferCard, Tuple.second concreteOfferCard ]


genericOfferCardView : GenericOfferCardDetails -> Html Msg
genericOfferCardView genericDetails =
    case genericDetails.offerType of
        HotDeal ->
            text "It's a Hot Deal"

        NonHotDeal ->
            text "It's Not a Hot Deal"


cashOfferCardView : CashOfferCardDetails -> Html Msg
cashOfferCardView offerDetails =
    div [] [ div [] [ text <| String.fromFloat offerDetails.offer ] ]


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

        ToggleState ->
            case model.state of
                WaitingForOffers ->
                    ( { model | state = OffersReceived }, Cmd.none )

                OffersReceived ->
                    ( { model | state = OffersExpired }, Cmd.none )

                OffersExpired ->
                    ( { model | state = WaitingForOffers }, Cmd.none )


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
