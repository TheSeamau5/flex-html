# flex-html
Flexbox layout for elm-html

This library contains several facilities for laying out Html with elm-html using flexbox.

To illustrate how it works, here is an example of how to do the holy grail layout using flex-html

### Holy Grail Layout

```elm
background : String -> Html
background color =
  let
      backgroundStyles =
        [ ("background-color", color)
        ]

  in
      flexDiv backgroundStyles [] []


holyGrail : Html
holyGrail =
  let
      topSection = background "red"
      bottomSection = background "black"

      leftSection = background "blue"
      rightSection = background "yellow"
      centerSection = background "green"

      mainSection = row
        [ leftSection
        , flexN 4 centerSection
        , rightSection
        ]

  in
      column
        [ topSection
        , flexN 8 mainSection
        , bottomSection
        ]


main : Html
main = fullbleed holyGrail
```

We populate the page with distinctly colored backgrounds (hence, the use of a `background` function).

The holy grail layout has 5 sections: a top row section, a bottom row section, a left column section, a right column section, and a center content section.

Each section is created as a background with a unique color to distinguish them:

```elm
topSection = background "red"
bottomSection = background "black"
leftSection = background "blue"
rightSection = background "yellow"
centerSection = background "green"
```

An then we simply lay them out. We first consider the vertically flowing sections. So we lay the top section atop a main section atop a bottom section as follows: 

```elm
column
  [ topSection
  , flexN 8 mainSection
  , bottomSection
  ]
```

Where the main section is a horizontal layout of the left section, the center section, and the right section (from left to right) and is defined as follows:

```elm
mainSection = row
  [ leftSection
  , flexN 4 centerSection
  , rightSection
  ]
```

And then, to display the page fullscreen, we simply call `fullbleed` as follows:

```elm
main = fullbleed holyGrail
```

Note the use of `flexN` in the code. `flexN` sets the flex size of an Html element. A `flexN` of 8, for example, means that an element will try to occupy a space 8x as large as an element that hasn't a set flex size or has set it to a default of `1`. 

Furthermore, note the use of `flexDiv`. `flexDiv` is an analog of `div` and is by no means necessary to use flexbox. Unfortunately, a common mistake with flexbox is to assume that a child div for which a width and a height is undefined will magically flex to fit the available dimensions of its parent. This is not how flexbox works and is perhaps one of the confusing bits of flexbox as it often leads to well positioned elements but whose width or height is equal to zero. In order to compensate for this confusion, `flexDiv` was introduced and basically does what you think it does (you don't need to specify dimensions for the element to appear as intended). Use `flexDiv` (and its complement `flexNode`) if this is the behavior you want. If instead you wish to specify the dimensions of an element, simply use the regular `div` or `node` functions in elm-html. Please refer to the docs for additional information on `flexDiv` and `flexNode`.
