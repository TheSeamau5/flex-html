# flex-html
This library contains several affordances for laying out Html with elm-html using flexbox.

To illustrate how it works, here is an example of how to do the holy grail layout using flex-html

### Holy Grail Layout

```elm
background : Float -> String -> Html
background grow color =
  let
      backgroundStyles =
        ("background-color", color)
        :: Flex.grow grow
  in
      div
        [ style backgroundStyles ]
        []


holyGrail : Html
holyGrail =
  let
      topSection    = background 1 "red"
      bottomSection = background 1 "black"
      leftSection   = background 1 "blue"
      rightSection  = background 1 "yellow"
      centerSection = background 4 "green"

      styleList =
        Flex.direction Flex.Horizontal
        ++ Flex.grow 8
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
        ++ Flex.direction Flex.Vertical

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
```

We populate the page with distinctly colored backgrounds (hence, the use of a `background` function).

The holy grail layout has 5 sections: a top row section, a bottom row section, a left column section, a right column section, and a center content section.

Each section is created as a background with a unique color to distinguish them:

```elm
topSection    = background 1 "red"
bottomSection = background 1 "black"
leftSection   = background 1 "blue"
rightSection  = background 1 "yellow"
centerSection = background 4 "green"
```

An then we simply lay them out. We first consider the vertically flowing sections. So we lay the top section atop a main section atop a bottom section as follows:

```elm
mainStyleList =
  [ ("width", "100vw")
  , ("height", "100vh")
  ]
  ++ Flex.display
  ++ Flex.direction Flex.Vertical

{-| ... -}

div
  [ style mainStyleList ]
  [ topSection
  , mainSection
  , bottomSection
  ]
```

Where the main section is a horizontal layout of the left section, the center section, and the right section (from left to right) and is defined as follows:

```elm
styleList =
  Flex.direction Flex.Horizontal
  ++ Flex.grow 8
  ++ Flex.display

mainSection =
  div
    [ style styleList ]
    [ leftSection
    , centerSection
    , rightSection
    ]
```

And that's how one would implement the holy grail with flex-html.

### Advanced layout example

flex-html is implemented as a collection of mixins. Each mixin allows you to define a flex property for a parent or child.

To illustrate how you can use these mixins, here is an example of positioning labels in a manner which would otherwise be insanely difficult:

```elm
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
```

So, as you may see, we have a helper function called `label` to create our labels.

We then layout the left label, the three central labels and the right label horizontally with:

```elm
containerStyle =
  ("width", "100vw")
  :: ("height", "100vh")
  :: Flex.justifyContent Flex.Surround
  ++ Flex.alignItems Flex.Center
  ++ Flex.wrap Flex.NoWrap
  ++ Flex.display
```
where:
* `justifyContent Surround` implies that the children will be equally spaced along the main axis (in this case, the horizontal axis)
* `wrap NoWrap` implies that the children will not wrap if there isn't enough space to flex (not a concern in this example)
* `alignItems Center` makes sure to center the items
* `display` applies flex display on the div
* `horizontal` is the default direction and thus main axis

And the central section (containing the top, centered, and bottom labels) are laid out using:

```elm
innerContainerStyle =
  ("height", "100%")
  :: Flex.flow Flex.Vertical Flex.NoWrap
  ++ Flex.justifyContent Flex.Surround
  ++ Flex.alignItems Flex.Center
  ++ Flex.display
```
where:
* `flow Vertical NoWrap` sets Vertical as the direction, making that the main axis and disable wrapping as seen previously

There are more mixins available. You can learn about these in the documentation as a reader exercise.
