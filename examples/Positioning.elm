import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Flex

----------------------
-- POSITIONING EXAMPLE
----------------------

label : String -> Html
label value =
  div
    [ [ ("background-color", "red")
      , ("color", "white")
      , ("padding", "5px")
      , ("font-weight", "bold")
      ]
      |> style
    ]
    [ text value ]


main : Html
main =
  div
    [ ( Flex.justifyContent Flex.Surround
        ++ Flex.alignItems Flex.Center
        ++ Flex.wrap Flex.NoWrap
        ++ Flex.display
        ++ [ ("width", "100vw"), ("height", "100vh") ]
      ) |> style
    ]
    [ label "I am on the left"
    , div
        [ Flex.flow Flex.Vertical Flex.NoWrap
          ++ Flex.justifyContent Flex.Surround
          ++ Flex.alignItems Flex.Center
          ++ Flex.display
          ++ [ ("height", "100%") ]
          |> style
        ]
        [ label "I am on top"
        , label "I am absolutely centered"
        , label "I am down below"
        ]
    , label "I am on the right"
    ]