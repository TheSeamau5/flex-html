module Flex
  ( column
  , columnReverse
  , row
  , rowReverse
  , flex
  , flexN
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

-}

import Html (Html, div)
import Html.Attributes (style)

container : String -> List Html -> Html
container direction =
  let
      containerStyle = style
        [ ("display", "flex")
        , ("flex-direction", direction)
        , ("flex", "1 1 auto")
        ]

  in
      div [containerStyle]

{-| Align children vertically from top to bottom
-}
column : List Html -> Html
column =
  container "column"

{-| Align children vertically from bottom to top
-}
columnReverse : List Html -> Html
columnReverse =
  container "column-reverse"

{-| Align children horizontally from left to right
-}
row : List Html -> Html
row =
  container "row"

{-| Align children horizontally from right to left
-}
rowReverse : List Html -> Html
rowReverse =
  container "row-reverse"

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
      elementStyle = style
        [ ("flex", (toString factor) ++ " 1 auto")
        , ("display", "flex")
        ]

  in
      div [elementStyle] [element]

{-| Wraps an element in a flex container that takes the size of the entire
screen. Use this only at the top level for the full view. This is not intended
to be used on individual Html nodes but rather once on the entire view.
-}
fullbleed : Html -> Html
fullbleed element =
  let
      elementStyle = style
        [ ("width", "100vw")
        , ("height", "100vh")
        , ("display", "flex")
        ]
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
  let
      directionString = case direction of
        Horizontal -> "row"
        Vertical -> "column"
        HorizontalReverse -> "row-reverse"
        VerticalReverse -> "column-reverse"

      alignString = case align of
        Start -> "flex-start"
        Center -> "center"
        End -> "flex-end"
        Stretch -> "strech"
        Surround -> "baseline"

      justifyString = case justify of
        Start -> "flex-start"
        Center -> "center"
        End -> "flex-end"
        Stretch -> "space-between"
        Surround -> "space-around"

      wrapString = case wrap of
        Wrap -> "wrap"
        NoWrap -> "nowrap"
        WrapReverse -> "wrap-reverse"

      containerStyle = style
        [ ("display", "flex")
        , ("flex-direction", directionString)
        , ("justify-content", justifyString)
        , ("align-items", alignString)
        , ("width", "100%")
        , ("height", "100%")
        ]

  in
      div [containerStyle]



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
