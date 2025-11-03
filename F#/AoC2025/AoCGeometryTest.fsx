#load "AoCUtil.fs"
#load "AoCGeometry.fs"


open AoC.Geometry
open AoC.Util

// d8888b. d888888b d8888b. d88888b  .o88b. d888888b d888888b  .d88b.  d8b   db
// 88  `8D   `88'   88  `8D 88'     d8P  Y8 `~~88~~'   `88'   .8P  Y8. 888o  88
// 88   88    88    88oobY' 88ooooo 8P         88       88    88    88 88V8o 88
// 88   88    88    88`8b   88~~~~~ 8b         88       88    88    88 88 V8o88
// 88  .8D   .88.   88 `88. 88.     Y8b  d8    88      .88.   `8b  d8' 88  V888
// Y8888D' Y888888P 88   YD Y88888P  `Y88P'    YP    Y888888P  `Y88P'  VP   V8P
let testDirectionOffset () =
    let n = Direction.offset Direction.N
    assertEqual {x = 0; y = -1} n
    let sw = Direction.offset Direction.SW
    assertEqual {x= -1; y = 1} sw

testDirectionOffset()

let testDirectionFromStrings () = 
    let n = Direction.fromString "N"
    assertTrue n.IsSome
    assertEqual Direction.N n.Value
    let w = Direction.fromString "L"
    assertTrue w.IsSome
    assertEqual Direction.W w.Value
    let e = Direction.fromString ">"
    assertTrue e.IsSome
    assertEqual Direction.E e.Value
    let x = Direction.fromString "x"
    assertTrue x.IsNone

testDirectionFromStrings()

//  .o88b.  .d88b.   .d88b.  d8888b. d8888b.
// d8P  Y8 .8P  Y8. .8P  Y8. 88  `8D 88  `8D
// 8P      88    88 88    88 88oobY' 88   88
// 8b      88    88 88    88 88`8b   88   88
// Y8b  d8 `8b  d8' `8b  d8' 88 `88. 88  .8D
//  `Y88P'  `Y88P'   `Y88P'  88   YD Y8888D'
let testCoordCreate () =
    let c = mkCoord 10 30
    assertEqual 10L c.x
    assertEqual 30L c.y
    let copied = {c with y = -40}
    assertEqual 10L copied.x
    assertEqual -40L copied.y

testCoordCreate ()

let testCoordAddSub () =
    let c1 = mkCoord 10 30
    let c2 = mkCoord 5 20
    let sum = Coord.add c1 c2
    assertEqual 15L sum.x
    assertEqual 50L sum.y
    let delta = Coord.delta c1 c2
    assertEqual -5L delta.x
    assertEqual -10L delta.y
    
testCoordAddSub ()

let testCoordDistance () = 
    let c1 = mkCoord 10 30
    let c2 = mkCoord 5 20
    let md = Coord.manhattanDistance c1 c2
    assertEqual 15L md
    let d = Coord.distance c1 c2
    assertTrue (AoC.Util.approxEqual 0.01 d 11.18)

testCoordDistance ()

let testCoordOffsets () = 
    assertEqual {x = 0; y = -1} (Coord.offset Direction.N 1L Coord.origin)
    assertEqual {x = -1; y = 1} (Coord.offset Direction.SW 1L Coord.origin)

testCoordOffsets ()

let testCoordAdjacency () =
    let cHorz = Direction.offset Direction.E
    assertTrue (Coord.areAdjacent cHorz Coord.origin AdjacencyRule.Rook)
    assertFalse (Coord.areAdjacent cHorz Coord.origin AdjacencyRule.Bishop)
    assertTrue (Coord.areAdjacent cHorz Coord.origin AdjacencyRule.Queen)
    let cDiag = Direction.offset Direction.SE
    assertFalse (Coord.areAdjacent cDiag Coord.origin AdjacencyRule.Rook)
    assertTrue (Coord.areAdjacent cDiag Coord.origin AdjacencyRule.Bishop)
    assertTrue (Coord.areAdjacent cDiag Coord.origin AdjacencyRule.Queen)
    let cFar = {x = 2; y = 0}
    assertFalse (Coord.areAdjacent cFar Coord.origin AdjacencyRule.Queen)

    let rookAdj = Coord.adjacentCoords Coord.origin AdjacencyRule.Rook
    assertEqual 4 rookAdj.Length
    let bishopAdj = Coord.adjacentCoords Coord.origin AdjacencyRule.Bishop
    assertEqual 4 bishopAdj.Length
    let queenAdj = Coord.adjacentCoords Coord.origin AdjacencyRule.Queen
    assertEqual 8 queenAdj.Length

testCoordAdjacency ()

// d8888b.  .d88b.  .d8888. d888888b d888888b d888888b  .d88b.  d8b   db
// 88  `8D .8P  Y8. 88'  YP   `88'   `~~88~~'   `88'   .8P  Y8. 888o  88
// 88oodD' 88    88 `8bo.      88       88       88    88    88 88V8o 88
// 88~~~   88    88   `Y8b.    88       88       88    88    88 88 V8o88
// 88      `8b  d8' db   8D   .88.      88      .88.   `8b  d8' 88  V888
// 88       `Y88P'  `8888Y' Y888888P    YP    Y888888P  `Y88P'  VP   V8P
let testPositionCreate () =
    let e = mkPos {x = 5; y = 5} Direction.E
    assertEqual {x = 5; y = 5} e.coord
    assertEqual Direction.E e.dir

testPositionCreate ()

let testPositionTurn () =
    let p1 = mkPos Coord.origin Direction.N
    let mutable p = Position.turn p1 RotationDirection.CW
    assertEqual p.dir Direction.E
    p <- Position.turn p RotationDirection.CCW
    assertEqual p.dir Direction.N

    for i in [1 .. 5] do
        p <- Position.turn p RotationDirection.CW
    assertEqual Direction.E p.dir

testPositionTurn ()

let testPositionMove () = 
    let p = mkPos Coord.origin Direction.S
    let pNear = Position.moveForward p 1
    assertEqual 1L pNear.coord.y
    assertEqual 0L pNear.coord.x
    let pFar = Position.moveForward p 100
    assertEqual 100L pFar.coord.y

testPositionMove ()

// .d8888. d88888b  d888b  .88b  d88. d88888b d8b   db d888888b
// 88'  YP 88'     88' Y8b 88'YbdP`88 88'     888o  88 `~~88~~'
// `8bo.   88ooooo 88      88  88  88 88ooooo 88V8o 88    88   
//   `Y8b. 88~~~~~ 88  ooo 88  88  88 88~~~~~ 88 V8o88    88   
// db   8D 88.     88. ~8~ 88  88  88 88.     88  V888    88   
// `8888Y' Y88888P  Y888P  YP  YP  YP Y88888P VP   V8P    YP   
let testSegmentCreate () =
    let seg = mkSeg Coord.origin {x = 1; y = 0}
    assertEqual 0L seg.a.x
    assertEqual 0L seg.a.y
    assertEqual 1L seg.b.x
    assertEqual 0L seg.b.y

testSegmentCreate ()

let testSegmentDirectionality () =
    let segHE = mkSeg Coord.origin {x = 1; y = 0}
    assertTrue (Segment.isHorizontal segHE)
    assertFalse (Segment.isVertical segHE)
    assertEqual (Segment.direction segHE) Direction.E
    let segHW = mkSeg Coord.origin {x = -1; y = 0}
    assertTrue (Segment.isHorizontal segHW)
    assertFalse (Segment.isVertical segHW)
    assertEqual (Segment.direction segHW) Direction.W

    let segDiagSE = mkSeg Coord.origin (Direction.offset Direction.SE)
    assertFalse (Segment.isHorizontal segDiagSE)
    assertFalse (Segment.isVertical segDiagSE)
    assertEqual (Segment.direction segDiagSE) Direction.SE
    let segDiagSW = mkSeg Coord.origin (Direction.offset Direction.SW)
    assertEqual (Segment.direction segDiagSW) Direction.SW
    let segDiagNW = mkSeg Coord.origin (Direction.offset Direction.NW)
    assertEqual (Segment.direction segDiagNW) Direction.NW
    let segDiagNE = mkSeg Coord.origin (Direction.offset Direction.NE)
    assertEqual (Segment.direction segDiagNE) Direction.NE

testSegmentDirectionality ()

let testSegmentLength () = 
    let sZero = mkSeg {x = 5; y = 5} {x = 5; y = 5}
    assertEqual 0L (Segment.length sZero)
    assertEqual Direction.N (Segment.direction sZero)

testSegmentLength ()

// d88888b db    db d888888b d88888b d8b   db d888888b
// 88'     `8b  d8' `~~88~~' 88'     888o  88 `~~88~~'
// 88ooooo  `8bd8'     88    88ooooo 88V8o 88    88   
// 88~~~~~  .dPYb.     88    88~~~~~ 88 V8o88    88   
// 88.     .8P  Y8.    88    88.     88  V888    88   
// Y88888P YP    YP    YP    Y88888P VP   V8P    YP   

let testExtentCreate () =
    let c1 = mkCoord -1 1
    let c2 = mkCoord 2 8
    let c3 = mkCoord 3 3
    let c4 = mkCoord 4 4
    let e1 = mkExtent [c1;c2]
    let e2 = mkExtent [c3;c2;c1]
    let e3 = Extent.expandToFit e2 [c4]
    assertEqual {min = {x = -1; y = 1}; max = {x = 2; y = 8}} e1
    assertEqual {min = {x = -1; y = 1}; max = {x = 3; y = 8}} e2
    assertEqual {min = {x = -1; y = 1}; max = {x = 4; y = 8}} e3

testExtentCreate ()

let testExtentBounds () =
    let e0 = mkExtI -1 1 2 8
    let e1 = mkExtI -1 1 3 8
    let e2 = mkExtI -1 1 4 8
    assertEqual 4L (Extent.widthOf e0)
    assertEqual 8L (Extent.heightOf e0)
    assertEqual 40L (Extent.areaOf e1)
    assertEqual {x = -1; y = 1} (Extent.NW e2)
    assertEqual {x = -1; y = 8} (Extent.SW e2)

testExtentBounds()

let testExtentAllCoords () =
    let e1 = mkExtI -1 1 3 8
    let coords = Extent.allCoordsIn e1
    assertEqual (Extent.areaOf e1) coords.Length
    // Check Reading Order
    assertEqual {x = -1; y = 1} coords.Head
    assertEqual {x = 0; y = 1} coords[1]
    assertEqual {x = 3; y = 8} coords[coords.Length-1]

testExtentAllCoords()

let testExtentTopology () =
    let e0 = mkExtI -1 1 2 8
    assertEqual (mkExtI 0 2 1 7) (Extent.inset e0 1L)
    assertEqual (mkExtI 0 3 1 6) (Extent.inset e0 2L) // xmin and xmax cross each other
    assertEqual (mkExtI -2 0 3 9) (Extent.inset e0 -1L)

    let e1 = mkExtI 1 1 10 10
    let e3 = Extent.intersect e1 (mkExtI 5 5 12 12)
    let e4 = Extent.intersect e1 (mkExtI 5 5 7 7)
    let e5 = Extent.intersect e1 (mkExtI 1 1 12 2)
    let e6 = Extent.intersect e1 (mkExtI 11 11 12 12)
    let e7 = Extent.intersect e1 (mkExtI 1 10 10 20)

    assertTrue e3.IsSome
    assertEqual e3.Value (mkExtI 5 5 10 10)
    assertTrue e4.IsSome
    assertEqual e4.Value (mkExtI 5 5 7 7)
    assertTrue e5.IsSome
    assertEqual e5.Value (mkExtI 1 1 10 2)
    assertTrue e6.IsNone
    assertTrue e7.IsSome
    assertEqual e7.Value (mkExtI 1 10 10 10)

testExtentTopology()

let testExtentUnion () =
    let ext = mkExtI 1 1 10 10
    let products1 = Extent.union ext (mkExtI 5 5 12 12)
    let expected1 = [(mkExtI 5 5 10 10);(mkExtI 1 5 4 10);(mkExtI 1 1 4 4);(mkExtI 5 1 10 4);(mkExtI 11 5 12 10);(mkExtI 11 11 12 12);(mkExtI 5 11 10 12)]
    assertEqual products1.Length expected1.Length
    assertEqual products1 expected1

    let products2 = Extent.union ext (mkExtI 5 5 7 7)
    let expected2 = [(mkExtI 5 5 7 7);(mkExtI 1 5 4 7);(mkExtI 1 1 4 4);(mkExtI 5 1 7 4);(mkExtI 8 1 10 4);(mkExtI 8 5 10 7);(mkExtI 8 8 10 10);(mkExtI 5 8 7 10);(mkExtI 1 8 4 10)]
    assertEqual products2.Length expected2.Length
    assertEqual products2 expected2

    let products3 = Extent.union ext (mkExtI 1 1 12 2)
    let expected3 = [(mkExtI 1 1 10 2);(mkExtI 1 3 10 10);(mkExtI 11 1 12 2)]
    assertEqual products3.Length expected3.Length
    assertEqual products3 expected3

    let products4 = Extent.union ext (mkExtI 11 11 12 12)
    let expected4 = [ext; mkExtI 11 11 12 12]
    assertEqual products4.Length expected4.Length
    assertEqual products4 expected4

    let products5 = Extent.union ext (mkExtI 1 10 10 20)
    let expected5 = [(mkExtI 1 10 10 10);(mkExtI 1 1 10 9);(mkExtI 1 11 10 20)]
    assertEqual products5.Length expected5.Length
    assertEqual products5 expected5

testExtentUnion()

printfn $"**** All tests passed. ****"