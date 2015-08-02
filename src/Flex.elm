module Flex where

{-| Companion library to elm-html. Helps with flexbox layout

# Flex Types
@docs Direction, Alignment, WrapValue

# Flex Mixins
Mixins can be used alone or as a combinator to specify flex-related styles.
@docs display, flow, direction, wrap, alignItems, justifyContent, grow, shrink, basis, flex, order, alignSelf

-}

import Vendor


{-| The `Direction` type specifies all the direction values possible for the `flexDirection` mixin.

    Horizontal: Default value. The flexible items are displayed horizontally, as a row.
    Vertical: The flexible items are displayed vertically, as a column.
    HorizontalReverse: Same as `Horizontal`, but in reverse order.
    verticalReverse: Same as `Vertical`, but in reverse order.
-}
type Direction
  = Horizontal
  | Vertical
  | HorizontalReverse
  | VerticalReverse


{-| The `Alignment` type specifies all the values possible for the `alignItems` and `justifyConteent` mixins.

    Start: Content is left-aligned.
    Center: Content is center-aligned.
    End: Content is right-aligned.
    Stretch: Content-width is stretched to fill up the space.
    Surround: Extra space is devided into equal spaces around the content.
-}
type Alignment
  = Start
  | Center
  | End
  | Stretch
  | Surround


{-| The `WrapValue` type specifies all the wrapping values possible for the `wrap` mixin.
    
    Wrap: Specifies that the flexible items will wrap if necessary.
    NoWrap: Default value. Specifies that the flexible items will not wrap.
    WrapReverse: Specifies that the flexible items will wrap, if necessary, in reverse order.
-}
type WrapValue
  = Wrap
  | NoWrap
  | WrapReverse


{-| Displays an element as an block-level flex container. -}
display : List (String, String)
display =
  let displayValue =
        if Vendor.prefix == Vendor.Webkit
        then "-webkit-flex"
        else "flex"
  in
    [ ("display", displayValue) ]


{-| The `flow` mixin specifies how much the item will grow relative to the rest of the flexible items inside the same container.
-}
flow: Direction -> WrapValue -> List (String, String)
flow directionValue wrapValue =
  direction directionValue
  ++ wrap wrapValue


{-| The `direction` mixin specifies the direction of the flexible items.
  -}
direction : Direction -> List (String, String)
direction directionValue =
  let (boxDirection, boxOrientation, value) =
        case directionValue of
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
    , ("-ms-flex-direction", value)
    , ("flex-direction", value)
    ]


{-| The `wrap` mixin specifies whether the flexible items should wrap or not.
  -}
wrap : WrapValue -> List (String, String)
wrap wrapValue =
  let (vendorValue, value) =
     case wrapValue of
        Wrap ->
          ("wrap", "wrap")

        NoWrap ->
          ("none", "nowrap")

        WrapReverse ->
          ("wrap-reverse", "wrap-reverse")
  in
    [ ("-webkit-flex-wrap", value)
    , ("-ms-flex-wrap", vendorValue)
    , ("flex-wrap", value)
    ]


{-| The `alignItems` mixin specifies the default alignment for items inside the flexible container.
  -}
alignItems : Alignment -> List (String, String)
alignItems alignment =
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
    , ("-webkit-align-items", value)
    , ("-ms-flex-align", vendorValue)
    , ("align-items", value)
    ]


{-| The `justifyContent` mixin aligns the flexible container's items when the items do not use all available space on the main-axis.
-}
justifyContent : Alignment -> List (String, String)
justifyContent alignment =
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
    , ("-webkit-justify-content", value)
    , ("-ms-flex-pack", msValue)
    , ("justify-content", value)
    ]


{-| The `grow` mixin specifies how much the item will grow relative to the rest of the flexible items inside the same container.
-}
grow : String -> List (String, String)
grow growValue =
  [ ("-webkit-box-flex", growValue)
  , ("-webkit-flex-grow", growValue)
  , ("-ms-flex-positive", growValue)
  , ("flex-grow", growValue)
  ]


{-| The `shrink` mixin specifies how the item will shrink relative to the rest of the flexible items inside the same container.
-}
shrink : String -> List (String, String)
shrink shrinkValue =
  [ ("-webkit-flex-shrink", shrinkValue)
  , ("-ms-flex-negative", shrinkValue)
  , ("flex-shrink", shrinkValue)
  ]


{-| The `basis` mixin specifies the initial length of a flexible item.
-}
basis : String -> List (String, String)
basis basisValue =
  [ ("-webkit-flex-basis", basisValue)
  , ("-ms-flex-preferred-size", basisValue)
  , ("flex-basis", basisValue)
  ]


{-| The `flex` mixin specifies the length of the item, relative to the rest of the flexible items inside the same container.
    It's a style shorthand for flexGrow, flexShrink and flexBasis
-}
flex : String -> String -> String -> List (String, String)
flex grow shrink basis =
  let value =
        grow  ++ " " ++ shrink ++ " " ++ basis
  in
    [ ("-webkit-box-flex", grow)
    , ("-webkit-flex", value)
    , ("-ms-flex", value)
    , ("flex", value)
    ]


{-| The `order` mixin specifies the order of a flexible item relative to the rest of the flexible items inside the same container.
  -}
order : Int -> List (String, String)
order value =
  let string =
        toString value
  in
    [ ("-webkit-box-ordinal-group", string)
    , ("-webkit-order", string)
    , ("-ms-flex-order", string)
    , ("-order", string)
    ]


{-| The `alignSelf` mixin specifies the alignment for the selected item inside the flexible container.
  -}
alignSelf : Alignment -> List (String, String)
alignSelf alignment =
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
    [ ("-webkit-align-self", value)
    , ("-ms-flex-item-align", value)
    , ("align-self", value)
    ]