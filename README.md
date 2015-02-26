# flex-html
This library contains several affordances for laying out Html with elm-html using flexbox.

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

### Advanced layout example

flex-html contains a `layout` function which enables you to have a fine grained control on your layouts and create your own custom layout functions and not depend solely on the pre-defined `row` or `column` functions.

To illustrate how it works, here is an example of positioning labels in a manner which would otherwise be insanely difficult:

```elm
label : String -> Html
label value =
  div [style [("background-color", "red")]] [text value]

labels : Html
labels =
  layout horizontal surround stretch noWrap
    [ layout vertical center center noWrap [label "I am on the left"]
    , layout vertical surround center noWrap
      [ label "I am on top"
      , label "I am absolutely centered"
      , label "I am down below"
      ]
    , layout vertical center center noWrap [label "I am on the right"]
    ]


main : Html
main = fullbleed labels
```

So, as you may see, we have a helper function called `label` to create our labels. 

We then layout the left label, the three central labels and the right label horizontally with:

```elm
layout horizontal surround stretch noWrap
```
where:
* `horizontal` implies that the children will be laid out from left to right horizontally
* `surround` implies that the children will be equally spaced along the main axis (in this case, the horizontal axis)
* `stretch` implies that the children will take up as much space as possible along the cross axis (in this case, the vertical axis)
* `noWrap` implies that the children will not wrap if there isn't enough space to flex (not a concern in this example)


The right and left sections are centered using :

```elm
layout vertical center center noWrap
```
where:
* `vertical` implies that the children will be laid out from top to bottom
* `center` (on both arguments) implies that the element will be absolutely centered


And the central section (containing the top, centered, and bottom labels) are laid out using:

```elm
layout vertical surround center noWrap
```
Which ensures that the labels are equally spaced along the vertical axis `surround` and are centered along the horizontal axis `center`

To re-cap, `layout` takes arguments of the following kind
```elm
layout : Direction -> Alignment -> Alignment -> Wrap -> List Html -> Html
layout direction mainAxisAlignment crossAxisAlignment wrap children
```
