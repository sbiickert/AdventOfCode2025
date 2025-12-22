#load "AoCUtil.fs"
// #load "AoCGeometry.fs"
// #load "AoCGrid.fs"

// #load "Day06.fs"
// #time
// solveDay06 false |> ignore
// #time

let a:int array list = [[| 90 |]]

seq {1 .. 4} |> Seq.toList |> AoC.Util.combinations 2