module Flex
  ( column
  , columnReverse
  , row
  , rowReverse
  , flex
  , flexN
  , flexDiv
  , flexNode
  , fullbleed
  , layout
  , horizontal
  , horizontalReverse
  , vertical
  , verticalReverse
  , start
  , center
  , end
  , stretch
  , surround
  , wrap
  , noWrap
  , wrapReverse) where

{-| Companion library to elm-html. Helps with flexbox layout

# Basic layout containers
@docs row, column, rowReverse, columnReverse

# Flexing individual elements
@docs flex, flexN

# Making an element go fullscreen
@docs fullbleed

# Advanced flexbox layout
@docs layout

# Flex Direction
@docs horizontal, vertical, horizontalReverse, verticalReverse

# Flex Alignment
@docs start, center, end, stretch, surround

# Flex Wrapping
@docs wrap, noWrap, wrapReverse

# Creating flexbox-ready nodes
@docs flexNode, flexDiv

-}

import Html exposing (Html, div, Attribute, node)
import Html.Attributes exposing (style)

{-| Analog of `node`. Creates a node (of given name), with a list of styles,
a list of attributes, and a list of children

    flexNode name styles attributes children

Note: The styles have been separated from the attributes in order for the flex attribute
to persist (in case the styles were overwritten). As a result, DO NOT include styles in
your attributes if you wish to use `flexNode`. Pass the styles to the function directly.
This'll guarantee that things will go swimmingly :)
-}
flexNode : String -> List (String, String) -> List Attribute -> List Html -> Html
flexNode name styles attributes children =
  let
      flexAttribute = style
        ( mixinDisplay
          ++ (mixinFlex "1" "1" "auto")
          ++ styles
        )

  in
      node name (flexAttribute :: attributes) children


{-| Analog of `div`. Creates a div with a list of styles, a list of attributes,
and a list of children

    flexDiv styles attributes children

Note: The styles have been separated from the attributes in order for the flex attribute
to persist (in case the styles were overwritten). As a result, DO NOT include styles in
your attributes if you wish to use `flexDiv`. Pass the styles to the function directly.
This'll guarantee that things will go swimmingly :)
-}
flexDiv : List (String, String) -> List Attribute -> List Html -> Html
flexDiv =
  flexNode "div"


container : Direction -> List Html -> Html
container direction =
  let
      containerStyle = style
        ( mixinDisplay
          ++ (mixinDirection direction)
          ++ (mixinFlex "1" "1" "auto")
        )

  in
      div [containerStyle]

{-| Align children vertically from top to bottom
-}
column : List Html -> Html
column =
  container Vertical

{-| Align children vertically from bottom to top
-}
columnReverse : List Html -> Html
columnReverse =
  container VerticalReverse

{-| Align children horizontally from left to right
-}
row : List Html -> Html
row =
  container Horizontal

{-| Align children horizontally from right to left
-}
rowReverse : List Html -> Html
rowReverse =
  container HorizontalReverse

{-| Surround an Html element by a flex container.

Note: if `flex` does not seem to do what you think it should do,
consider adding the following style to the input Html node:

    ("flex", "1")

`flex` does not do this automatically. It creates a container around
a node rather than affect it directly.
-}
flex : Html -> Html
flex =
  flexN 1


{-| Surround an Html element by a flex container of a given flex size.

Note: if `flexN` does not seem to do what you think it should do,
consider adding the following style to the input Html node:

    ("flex", "1")

`flexN` does not do this automatically. It creates a container around
a node rather than affect it directly.
-}
flexN : Int -> Html -> Html
flexN factor element =
  let
      elementStyles = style
        ( mixinDisplay
          ++ (mixinFlex (toString factor) "1" "auto")
        )

  in
      div [elementStyles] [element]

{-| Wraps an element in a flex container that takes the size of the entire
screen. Use this only at the top level for the full view. This is not intended
to be used on individual Html nodes but rather once on the entire view.
-}
fullbleed : Html -> Html
fullbleed element =
  let
      elementStyle = style
        ( ("width", "100vw") ::
          ("height", "100vh") ::
          mixinDisplay
        )
  in
      div [elementStyle] [element]


{-| Allows you to construct a custom flex container by setting various
parameters.

    layout direction justify align wrap children

* `direction` dictates the direction the children will flow.
The choices are : `horizontal`, `vertical`, `horizontalReverse`, `verticalReverse`

* `justify` dictates how the children align on the main-axis.
The choices are `start`, `center`, `end`, `stretch`, `surround`

* `align` dictates how the children align on the cross-axis
The choices are `start`, `center`, `end`, `stretch`, `surround`

* `wrap` dictates if the children wrap if there is no space left for them to flex
The choices are `wrap`, `noWrap`, `wrapReverse`
-}
layout : Direction -> Alignment -> Alignment -> Wrap -> List Html -> Html
layout direction justify align wrap =
  let containerStyles = style
        ( mixinDisplay
          ++ (mixinDirection direction)
          ++ (mixinJustifyContent justify)
          ++ (mixinAlign align)
          ++ (mixinWrap wrap)
          ++ (mixinFlex "1" "1" "auto")
          ++ [ ("width", "100%"), ("height", "100%") ]
        )
  in
      div [containerStyles]



type Direction
  = Horizontal
  | Vertical
  | HorizontalReverse
  | VerticalReverse

horizontal : Direction
horizontal = Horizontal

vertical : Direction
vertical = Vertical

horizontalReverse : Direction
horizontalReverse = HorizontalReverse

verticalReverse : Direction
verticalReverse = VerticalReverse

type Alignment
  = Start
  | Center
  | End
  | Stretch
  | Surround

start : Alignment
start = Start

center : Alignment
center = Center

end : Alignment
end = End

stretch : Alignment
stretch = Stretch

surround : Alignment
surround = Surround


type Wrap
  = Wrap
  | NoWrap
  | WrapReverse

wrap : Wrap
wrap = Wrap

noWrap : Wrap
noWrap = NoWrap

wrapReverse : Wrap
wrapReverse = WrapReverse


{-| Flex Mixins to support older and vendor-specific syntax as well.
-}

mixinDisplay : List (String, String)
mixinDisplay  =
  [ ("display", "-webkit-box")
  , ("display", "-webkit-flex")
  , ("display", "-moz-flex")
  , ("display", "-ms-flexbox")
  , ("display", "flex")
  ]

mixinDirection : Direction -> List (String, String)
mixinDirection direction =
  let (boxDirection, boxOrientation, value) =
        case direction of
          Horizontal ->
            ("normal", "horizontal", "row")

          Vertical ->
            ("normal", "vertical", "column")

          HorizontalReverse ->
            ("reverse", "horizontal", "row-reverse")

          VerticalReverse ->
            ("reverse", "vertical", "column-reverse")
  in
    [ ("-webkit-box-direction", boxDirection)
    , ("-webkit-box-orient", boxOrientation)
    , ("-webkit-flex-direction", value)
    , ("-moz-flex-direction", value)
    , ("-ms-flex-direction", value)
    , ("flex-direction", value)
    ]

mixinWrap : Wrap -> List (String, String)
mixinWrap wrap =
  let (vendorValue, value) =
     case wrap of
        Wrap ->
          ("wrap", "wrap")

        NoWrap ->
          ("none", "nowrap")

        WrapReverse ->
          ("wrap-reverse", "wrap-reverse")
  in
    [ ("-webkit-flex-wrap", value)
    , ("-moz-flex-wrap", value)
    , ("-ms-flex-wrap", vendorValue)
    , ("flex-wrap", value)
    ]

mixinAlign : Alignment -> List (String, String)
mixinAlign alignment =
  let (vendorValue, value) =
        case alignment of
          Start ->
            ("start", "flex-start")

          Center ->
            ("center", "center")

          End ->
            ("end", "flex-end")

          Stretch ->
            ("stretch", "stretch")

          Surround ->
            ("baseline", "baseline")
  in
    [ ("-webkit-box-align", vendorValue)
    , ("-ms-flex-align", vendorValue)
    , ("-webkit-align-items", value)
    , ("-moz-align-items", value)
    , ("align-items", value)
    ]

mixinJustifyContent : Alignment -> List (String, String)
mixinJustifyContent alignment =
  let (webkitValue, msValue, value) =
        case alignment of
          Start ->
            ("start", "start", "flex-start")

          Center ->
            ("center", "center", "center")

          End ->
            ("end", "end", "flex-end")

          Stretch ->
            ("justify", "justify", "space-between")

          Surround ->
            ("none", "distribute", "space-around")
  in
    [ ("-webkit-box-pack", webkitValue)
    , ("-ms-flex-pack", msValue)
    , ("-webkit-justify-content", value)
    , ("-moz-justify-content", value)
    , ("justify-content", value)
    ]

mixinFlex : String -> String -> String -> List (String, String)
mixinFlex grow shrink basis =
  let value =
        grow ++ " " ++ shrink ++ " " ++ basis
  in
    [ ("-webkit-box-flex", grow)
    , ("-webkit-flex", value)
    , ("-moz-box-flex", grow)
    , ("-moz-flex", value)
    , ("-ms-flex", value)
    , ("flex", value)
    ]