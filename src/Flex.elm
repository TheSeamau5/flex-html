module Flex
  ( column
  , columnReverse
  , row
  , rowReverse
  , flexDiv
  , flexNode
  , fullbleed
  , layout
  , fullbleed
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
  , wrapReverse
  , display
  , flexFlow
  , flexDirection
  , flexWrap
  , alignItems
  , justifyContent
  , flexGrow
  , flexShrink
  , flexBasis
  , flex
  , order
  , alignSelf
  ) where

{-| Companion library to elm-html. Helps with flexbox layout

# Basic layout containers
@docs row, column, rowReverse, columnReverse

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

# Flex Mixins
Mixins can be used alone or as a combinator to specify flex-related styles.
@docs display, flexFlow, flexDirection, flexWrap, alignItems, justifyContent, flexGrow, flexShrink, flexBasis, flex, order, alignSelf

-}

import Html exposing (Html, div, Attribute, node)
import Html.Attributes exposing (style)

import Maybe exposing (..)
import Vendor


{-| Analog of `node`. Creates a node (of given name), with a list of styles,
a list of attributes, and a list of children

    flexNode name styles attributes children

Note: The styles have been separated from the attributes in order for the flex attribute
to persist (in case the styles were overwritten). As a result, DO NOT include styles in
your attributes if you wish to use `flexNode`. Pass the styles to the function directly.
This'll guarantee that things will go swimmingly :)
-}
flexNode : String -> String -> StringPairList -> List Attribute -> List Html -> Html
flexNode name grow styles attributes children =
  let
      flexAttribute =
        display styles
        |> flexGrow grow
        |> style
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
flexDiv : String -> StringPairList -> List Attribute -> List Html -> Html
flexDiv =
  flexNode "div"


container : Direction -> List Html -> Html
container direction =
  let
      containerStyle =
        display []
        |> flexDirection direction
        |> flexGrow "1"
        |> style
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


{-| Wraps an element in a flex container that takes the size of the entire
screen. Use this only at the top level for the full view. This is not intended
to be used on individual Html nodes but rather once on the entire view.
-}
fullbleed : Html -> Html
fullbleed element =
  let
      elementStyle =
        [("width", "100vw"), ("height", "100vh")]
        |> display
        |> style
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
  let containerStyles =
        display [("width", "100%"), ("height", "100%")]
        |> flexFlow direction wrap
        |> justifyContent justify
        |> alignItems align
        |> flexGrow "1"
        |> style
  in
      div [containerStyles]


type Direction
  = Horizontal
  | Vertical
  | HorizontalReverse
  | VerticalReverse

{-| Default value. The flexible items are displayed horizontally, as a row.
-}
horizontal : Direction
horizontal = Horizontal

{-| The flexible items are displayed vertically, as a column.
-}
vertical : Direction
vertical = Vertical

{-| Same as `horizontal`, but in reverse order.
-}
horizontalReverse : Direction
horizontalReverse = HorizontalReverse

{-| Same as `vertical`, but in reverse order.
-}
verticalReverse : Direction
verticalReverse = VerticalReverse


type Alignment
  = Start
  | Center
  | End
  | Stretch
  | Surround

{-| Content is left-aligned. -}
start : Alignment
start = Start

{-| Content is center-aligned. -}
center : Alignment
center = Center

{-| Content is right-aligned. -}
end : Alignment
end = End

{-| Content-width is stretched to fill up the space. -}
stretch : Alignment
stretch = Stretch

{-| Extra space is devided into equal spaces around the content. -}
surround : Alignment
surround = Surround


type Wrap
  = Wrap
  | NoWrap
  | WrapReverse

{-| Specifies that the flexible items will wrap if necessary. -}
wrap : Wrap
wrap = Wrap

{-| Default value. Specifies that the flexible items will not wrap. -}
noWrap : Wrap
noWrap = NoWrap

{-|Specifies that the flexible items will wrap, if necessary, in reverse order. -}
wrapReverse : Wrap
wrapReverse = WrapReverse


type alias StringPairList =  List (String, String)


{-| Displays an element as an block-level flex container. -}
display : StringPairList -> StringPairList
display attributes =
  let displayValue =
        if Vendor.prefix == Vendor.Webkit
        then "-webkit-flex"
        else "flex"
  in
    ("display", displayValue)
    :: attributes


{-| The flex-grow property specifies how much the item will grow relative to the rest of the flexible items inside the same container.
    Note: If the element is not a flexible item, the flex-grow property has no effect.
-}
flexFlow: Direction -> Wrap -> StringPairList -> StringPairList
flexFlow direction wrap attributes =
  flexDirection direction attributes
  |> flexWrap wrap


{-| The `flexDirection` mixin specifies the direction of the flexible items.
  -}
flexDirection : Direction -> StringPairList -> StringPairList
flexDirection direction attributes =
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
    ("-webkit-box-direction", boxDirection)
    :: ("-webkit-box-orient", boxOrientation)
    :: ("-webkit-flex-direction", value)
    :: ("-ms-flex-direction", value)
    :: ("flex-direction", value)
    :: attributes


{-| The `flexWrap` mixin specifies whether the flexible items should wrap or not.
  -}
flexWrap : Wrap -> StringPairList -> StringPairList
flexWrap wrap attributes =
  let (vendorValue, value) =
     case wrap of
        Wrap ->
          ("wrap", "wrap")

        NoWrap ->
          ("none", "nowrap")

        WrapReverse ->
          ("wrap-reverse", "wrap-reverse")
  in
    ("-webkit-flex-wrap", value)
    :: ("-ms-flex-wrap", vendorValue)
    :: ("flex-wrap", value)
    :: attributes


{-| The `alignItems` mixin specifies the default alignment for items inside the flexible container.
  -}
alignItems : Alignment -> StringPairList -> StringPairList
alignItems alignment attributes =
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
    ("-webkit-box-align", vendorValue)
    :: ("-webkit-align-items", value)
    :: ("-ms-flex-align", vendorValue)
    :: ("align-items", value)
    :: attributes


{-| The `justifyContent` mixin aligns the flexible container's items when the items do not use all available space on the main-axis.
-}
justifyContent : Alignment -> StringPairList -> StringPairList
justifyContent alignment attributes =
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
    ("-webkit-box-pack", webkitValue)
    :: ("-webkit-justify-content", value)
    :: ("-ms-flex-pack", msValue)
    :: ("justify-content", value)
    :: attributes


{-| The `flexGrow` mixin specifies how much the item will grow relative to the rest of the flexible items inside the same container.
-}
flexGrow : String -> StringPairList -> StringPairList
flexGrow grow attributes =
  ("-webkit-box-flex", grow)
  :: ("-webkit-flex-grow", grow)
  :: ("-ms-flex-positive", grow)
  :: ("flex-grow", grow)
  :: attributes


{-| The `flexShrink` mixin specifies how the item will shrink relative to the rest of the flexible items inside the same container.
-}
flexShrink : String -> StringPairList -> StringPairList
flexShrink shrink attributes =
  ("-webkit-flex-shrink", shrink)
  :: ("-ms-flex-negative", shrink)
  :: ("flex-shrink", shrink)
  :: attributes


{-| The `flexBasis` mixin specifies the initial length of a flexible item.
-}
flexBasis : String -> StringPairList -> StringPairList
flexBasis basis attributes =
  ("-webkit-flex-basis", basis)
  :: ("-ms-flex-preferred-size", basis)
  :: ("flex-basis", basis)
  :: attributes


{-| The `flex` mixin specifies the length of the item, relative to the rest of the flexible items inside the same container.
    It's a style shorthand for flexGrow, flexShrink and flexBasis
-}
flex : String -> String -> String -> StringPairList -> StringPairList
flex grow shrink basis attributes =
  let value =
        grow  ++ " " ++ shrink ++ " " ++ basis
  in
    ("-webkit-box-flex", grow)
    :: ("-webkit-flex", value)
    :: ("-ms-flex", value)
    :: ("flex", value)
    :: attributes


{-| The `order` mixin specifies the order of a flexible item relative to the rest of the flexible items inside the same container.
  -}
order : Int -> StringPairList -> StringPairList
order value attributes =
  let string =
        toString value
  in
    ("-webkit-box-ordinal-group", string)
    :: ("-webkit-order", string)
    :: ("-ms-flex-order", string)
    :: ("-order", string)
    :: attributes


{-| The `alignSelf` mixin specifies the alignment for the selected item inside the flexible container.
  -}
alignSelf : Alignment -> StringPairList -> StringPairList
alignSelf alignment attributes =
  let value =
        case alignment of
          Start ->
            "flex-start"

          Center ->
            "center"

          End ->
            "flex-end"

          Stretch ->
            "stretch"

          Surround ->
            "baseline"
  in
    ("-webkit-align-self", value)
    :: ("-ms-flex-item-align", value)
    :: ("align-self", value)
    :: attributes