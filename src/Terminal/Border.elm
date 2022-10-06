module Terminal.Border exposing
    ( single
    , double
    , Border, bold, classic, custom, doubleSingle, draw, rounded, singleDouble
    )

{-| Styles borrowed from <https://www.npmjs.com/package/cli-boxes>

@docs single
@docs double

-}

import Ansi.Cursor


type Border
    = Border
        { topLeft : String
        , top : String
        , topRight : String
        , right : String
        , bottomRight : String
        , bottom : String
        , bottomLeft : String
        , left : String
        }


{-| A thin box with sharp corners

┌────┐
│ sl │
└────┘

-}
single : Border
single =
    Border
        { topLeft = "┌"
        , top = "─"
        , topRight = "┐"
        , right = "│"
        , bottomRight = "┘"
        , bottom = "─"
        , bottomLeft = "└"
        , left = "│"
        }


{-| 2 thin, nested boxes with sharp corners

╔════╗
║ db ║
╚════╝

-}
double : Border
double =
    Border
        { topLeft = "╔"
        , top = "═"
        , topRight = "╗"
        , right = "║"
        , bottomRight = "╝"
        , bottom = "═"
        , bottomLeft = "╚"
        , left = "║"
        }


{-| A thin box with rounded corners

╭────╮
│ rd │
╰────╯

-}
rounded : Border
rounded =
    Border
        { topLeft = "╭"
        , top = "─"
        , topRight = "╮"
        , right = "│"
        , bottomRight = "╯"
        , bottom = "─"
        , bottomLeft = "╰"
        , left = "│"
        }


{-| A thick box with sharp corners

┏━━━━┓
┃ bd ┃
┗━━━━┛

-}
bold : Border
bold =
    Border
        { topLeft = "┏"
        , top = "━"
        , topRight = "┓"
        , right = "┃"
        , bottomRight = "┛"
        , bottom = "━"
        , bottomLeft = "┗"
        , left = "┃"
        }


{-| A box with sharp corners, thin on the top and bottom and doubled up on the sides

╓────╖
║ sd ║
╙────╜

-}
singleDouble : Border
singleDouble =
    Border
        { topLeft = "╓"
        , top = "─"
        , topRight = "╖"
        , right = "║"
        , bottomRight = "╜"
        , bottom = "─"
        , bottomLeft = "╙"
        , left = "║"
        }


{-| A box with sharp corners, thin on the sides and doubled on top and bottom

╒════╕
│ ds │
╘════╛

-}
doubleSingle : Border
doubleSingle =
    Border
        { topLeft = "╒"
        , top = "═"
        , topRight = "╕"
        , right = "│"
        , bottomRight = "╛"
        , bottom = "═"
        , bottomLeft = "╘"
        , left = "│"
        }


{-| A thin box with plus shaped corners

+----+
| cs |
+----+

-}
classic : Border
classic =
    Border
        { topLeft = "+"
        , top = "-"
        , topRight = "+"
        , right = "|"
        , bottomRight = "+"
        , bottom = "-"
        , bottomLeft = "+"
        , left = "|"
        }


{-| Design your own box, suash as

•————•
∫ cm ∫
•————•

TODO: This may cause issues

-}
custom :
    { topLeft : Char
    , top : Char
    , topRight : Char
    , right : Char
    , bottomRight : Char
    , bottom : Char
    , bottomLeft : Char
    , left : Char
    }
    -> Border
custom options =
    Border
        { topLeft = String.fromChar options.topLeft
        , top = String.fromChar options.top
        , topRight = String.fromChar options.topRight
        , right = String.fromChar options.right
        , bottomRight = String.fromChar options.bottomRight
        , bottom = String.fromChar options.bottom
        , bottomLeft = String.fromChar options.bottomLeft
        , left = String.fromChar options.left
        }


draw : { width : Int, height : Int } -> Border -> String
draw dimensions (Border style) =
    [ style.topLeft
    , List.repeat (dimensions.width - 2) style.top |> String.concat
    , style.topRight
    , List.foldl
        (\right result ->
            result
                ++ Ansi.Cursor.moveDownBy 1
                ++ Ansi.Cursor.moveBackwardBy 1
                ++ right
        )
        ""
        (List.repeat (dimensions.height - 2) style.right)
    , Ansi.Cursor.moveDownBy 1
    , Ansi.Cursor.moveBackwardBy 1
    , style.bottomRight
    , Ansi.Cursor.moveBackwardBy (dimensions.width - 1)
    , List.repeat (dimensions.width - 2) style.bottom |> String.concat
    , Ansi.Cursor.moveBackwardBy dimensions.width
    , style.bottomLeft
    , Ansi.Cursor.moveBackwardBy 1
    , List.foldl
        (\left result ->
            result
                ++ Ansi.Cursor.moveUpBy 1
                ++ Ansi.Cursor.moveBackwardBy 1
                ++ left
        )
        ""
        (List.repeat (dimensions.height - 2) style.left)
    , Ansi.Cursor.moveUpBy 1
    ]
        |> String.concat
