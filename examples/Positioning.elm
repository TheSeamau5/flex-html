import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Flex

----------------------
-- POSITIONING EXAMPLE
----------------------

label : String -> Html
label value =
  let
      labelStyle =
        [ ("background-color", "red")
        , ("color", "white")
        , ("padding", "5px")
        , ("font-weight", "bold")
        ]
  in
      div
        [ style labelStyle ]
        [ text value ]


main : Html
main =
  let
      containerStyle =
        ("width", "100vw")
        :: ("height", "100vh")
        :: Flex.justifyContent Flex.Surround
        ++ Flex.alignItems Flex.Center
        ++ Flex.wrap Flex.NoWrap
        ++ Flex.display

      innerContainerStyle =
        ("height", "100%")
        :: Flex.flow Flex.Vertical Flex.NoWrap
        ++ Flex.justifyContent Flex.Surround
        ++ Flex.alignItems Flex.Center
        ++ Flex.display
  in
      div
        [ style containerStyle ]
        [ label "I am on the left"
        , div
            [ style innerContainerStyle ]
            [ label "I am on top"
            , label "I am absolutely centered"
            , label "I am down below"
            ]
        , label "I am on the right"
        ]
