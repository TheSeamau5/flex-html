module Example where

import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Flex exposing (..)

----------------------------
-- HOLY GRAIL LAYOUT EXAMPLE
----------------------------

background : String -> String -> Html
background grow color =
  let
      backgroundStyles =
        [ ("background-color", color)
        ]

  in
      flexDiv grow backgroundStyles [] []


holyGrail : Html
holyGrail =
  let
      topSection = background "1" "red"
      bottomSection = background "1" "black"

      leftSection = background "1" "blue"
      rightSection = background "1" "yellow"
      centerSection = background "4" "green"

      mainSection = row
        [ leftSection
        , centerSection
        , rightSection
        ]

  in
      column
        [ topSection
        , flexDiv "8" [] [] [mainSection]
        , bottomSection
        ]


main : Html
main =
  fullbleed holyGrail
