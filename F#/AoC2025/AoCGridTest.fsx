#load "AoCUtil.fs"
#load "AoCGeometry.fs"
#load "AoCGrid.fs"

open AoC.Util
open AoC.Geometry
open AoC.Grid

type GameObj =
    {
        name: string
        hp: int
    }

let testGrid () =
    let mutable grid = mkGrid "." AdjacencyRule.Rook
    assertEqual "." grid.defaultValue
    assertEqual AdjacencyRule.Rook grid.rule
    assertTrue grid.extent.IsNone

    let c = [| (mkCoord 1 1);(mkCoord 2 2);(mkCoord 3 3);(mkCoord 4 4);(mkCoord 1 4);(mkCoord 2 4);(mkCoord 3 4) |]
    grid <- setValue grid c[0] (Glyph "A")
    grid <- setValue grid c[1] (Glyph "B")
    grid <- setValue grid c[3] (Glyph "D")

    assertEqual "A" (getString grid c[0])
    assertEqual "B" (getString grid c[1])
    assertEqual grid.defaultValue (getString grid c[2])
    assertEqual "D" (getString grid c[3])
    
    assertTrue grid.extent.IsSome
    assertEqual c[0] grid.extent.Value.min
    assertEqual c[3] grid.extent.Value.max

    grid <- setValue grid c[4] (Complex ("E", {name = "Elf"; hp = 100}))
    grid <- setValue grid c[5] (Complex ("G", {name = "Goblin"; hp = 95}))
    grid <- setValue grid c[6] (Complex ("S", {name = "Santa"; hp = 1000}))

    assertEqual "E" (getString grid c[4])
    assertEqual "G" (getString grid c[5])
    let santaGridData = getValue grid c[6]
    match santaGridData with
    | Complex (glyph, santaObj:obj) -> 
        let santa = santaObj :?> GameObj
        assertEqual 1000 santa.hp
    | _ -> ()

    let allCoords = coords grid None
    assertEqual 6 allCoords.Length
    let coordsWithB = coords grid (Some "B")
    assertEqual c[1] coordsWithB.Head

    // Histogram
    grid <- setValue grid c[2] (Glyph "B")
    let hist = histogram grid false
    assertEqual 1 (hist.Item "A")
    assertEqual 2 (hist.Item "B")
    assertFalse (hist.ContainsKey grid.defaultValue)
    let histWithDefault = histogram grid true
    assertEqual 9 (histWithDefault.Item grid.defaultValue)

    //printGrid grid None
    let gridStr = sprintGrid grid None
    assertEqual "A...\n.B..\n..B.\nEGSD\n" gridStr

    let markers = Map [{x = 4; y = 1}, "*"]
    //printGrid grid (Some markers)
    let gridStrM = sprintGrid grid (Some markers)
    assertEqual "A..*\n.B..\n..B.\nEGSD\n" gridStrM

    // Clearing
    grid <- clear grid c[2] false
    assertEqual grid.defaultValue (getString grid c[2])
    let originalExt = grid.extent.Value
    let c100 = {x = 100; y = 100}
    grid <- setValue grid c100 (Glyph "X")
    assertEqual grid.extent.Value.max c100
    grid <- clear grid c100 true
    assertEqual originalExt grid.extent.Value


testGrid()

let testLoad () =
    let input = ["abcd";"e.gh";"ijkl"]
    let grid = loadGrid input "." AdjacencyRule.Rook
    let gridStr = sprintGrid grid None
    assertEqual "abcd\ne.gh\nijkl\n" gridStr
    assertEqual (getString grid Coord.origin) "a"
    assertEqual 11 (coords grid None).Length // The "." would not be set during load

testLoad()

printfn $"**** All tests passed. ****"
