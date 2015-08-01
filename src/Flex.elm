module Flex where

{-| Companion library to elm-html. Helps with flexbox layout

# Flex Types
@docs Direction, Alignment, WrapValue

# Flex Mixins
Mixins can be used alone or as a combinator to specify flex-related styles.
@docs display, flexFlow, flexDirection, flexWrap, alignItems, justifyContent, flexGrow, flexShrink, flexBasis, flex, order, alignSelf

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


{-| The `WrapValue` type specifies all the wrapping values possible for the `flexWrap` mixin.
    
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


{-| The flex-grow property specifies how much the item will grow relative to the rest of the flexible items inside the same container.
    Note: If the element is not a flexible item, the flex-grow property has no effect.
-}
flexFlow: Direction -> WrapValue -> List (String, String)
flexFlow direction wrap =
  flexDirection direction
  ++ flexWrap wrap


{-| The `flexDirection` mixin specifies the direction of the flexible items.
  -}
flexDirection : Direction -> List (String, String)
flexDirection direction =
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
    , ("-ms-flex-direction", value)
    , ("flex-direction", value)
    ]


{-| The `flexWrap` mixin specifies whether the flexible items should wrap or not.
  -}
flexWrap : WrapValue -> List (String, String)
flexWrap wrap =
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


{-| The `flexGrow` mixin specifies how much the item will grow relative to the rest of the flexible items inside the same container.
-}
flexGrow : String -> List (String, String)
flexGrow grow =
  [ ("-webkit-box-flex", grow)
  , ("-webkit-flex-grow", grow)
  , ("-ms-flex-positive", grow)
  , ("flex-grow", grow)
  ]


{-| The `flexShrink` mixin specifies how the item will shrink relative to the rest of the flexible items inside the same container.
-}
flexShrink : String -> List (String, String)
flexShrink shrink =
  [ ("-webkit-flex-shrink", shrink)
  , ("-ms-flex-negative", shrink)
  , ("flex-shrink", shrink)
  ]


{-| The `flexBasis` mixin specifies the initial length of a flexible item.
-}
flexBasis : String -> List (String, String)
flexBasis basis =
  [ ("-webkit-flex-basis", basis)
  , ("-ms-flex-preferred-size", basis)
  , ("flex-basis", basis)
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