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


redBackground = background "red"
blueBackground = background "blue"
greenBackground = background "green"
blackBackground = background "black"
yellowBackground = background "yellow"


holyGrail =
  column
    [ redBackground
    , flexN 8 (row
      [ blueBackground
      , flexN 4 greenBackground
      , yellowBackground
      ])
    , blackBackground
    ]


main = fullbleed holyGrail


----------------------
-- POSITIONING EXAMPLE
----------------------

label value = div [style [("background-color", "red")]] [text value]

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



--main = fullbleed labels
