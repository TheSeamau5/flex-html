import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Flex

----------------------------
-- HOLY GRAIL LAYOUT EXAMPLE
----------------------------

background : String -> String -> Html
background grow color =
  let backgroundStyles =
        Flex.flexGrow grow
        |> (::) ("background-color", color)
        |> style

  in
      div [backgroundStyles] []


holyGrail : Html
holyGrail =
  let topSection = background "1" "red"
      bottomSection = background "1" "black"

      leftSection = background "1" "blue"
      rightSection = background "1" "yellow"
      centerSection = background "4" "green"

      styleList =
        (Flex.flexDirection Flex.Horizontal)
        ++ (Flex.flexGrow "8")
        ++ Flex.display

      mainSection =
        div
          [ style styleList ]
          [ leftSection
          , centerSection
          , rightSection
          ]

      mainStyleList =
        [ ("width", "100vw")
        , ("height", "100vh")
        ]
        ++ Flex.display
        ++ (Flex.flexDirection Flex.Vertical)

  in
      div
        [ style mainStyleList ]
        [ topSection
        , mainSection
        , bottomSection
        ]


main : Html
main =
  holyGrail