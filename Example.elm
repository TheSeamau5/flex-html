import Html (Html, div, text)
import Html.Attributes (style)
import Flex (..)


----------------------------
-- HOLY GRAIL LAYOUT EXAMPLE
----------------------------

background : String -> Html
background color =
  let
      backgroundStyles =
        [ ("background-color", color)
        ]

  in
      flexDiv backgroundStyles [] []


holyGrail : Html
holyGrail =
  let
      topSection = background "red"
      bottomSection = background "black"

      leftSection = background "blue"
      rightSection = background "yellow"
      centerSection = background "green"

      mainSection = row
        [ leftSection
        , flexN 4 centerSection
        , rightSection]

  in
      column
        [ topSection
        , flexN 8 mainSection
        , bottomSection
        ]


main : Html
main = fullbleed holyGrail


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


--main : Html
--main = fullbleed labels
