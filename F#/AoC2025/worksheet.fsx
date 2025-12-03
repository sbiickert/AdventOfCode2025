#load "AoCUtil.fs"
// #load "AoCGeometry.fs"
// #load "AoCGrid.fs"

// #load "Day01.fs"
// #time
// solveDay01 false |> ignore
// #time


let nums =
    seq { 11 .. 22 } 
    |> Seq.map (fun id -> 
        let idStr = string id
        idStr)
    |> Seq.toList
printfn $"{nums}"