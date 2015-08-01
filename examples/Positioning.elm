import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Flex exposing (..)

----------------------
-- POSITIONING EXAMPLE
----------------------

label : String -> Html
label value =
  div [style [("background-color", "red")]] [text value]

labels : Html
labels =
  layout horizontal surround stretch noWrap
    [ layout vertical center center noWrap [label "I am on the left"]
    , layout vertical surround center noWrap
      [ label "I am on top"
      , label "I am absolutely centered"
      , label "I am down below"
      ]
    , layout vertical center center noWrap [label "I am on the right"]
    ]


main : Html
main =
  fullbleed labels