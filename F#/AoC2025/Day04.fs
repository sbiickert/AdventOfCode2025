[<AutoOpen>]
module Day04

open AoC.Util
open AoC.Geometry
open AoC.Grid

let countAdjacentRolls map coord: int =
    Grid.neighbors coord map
    |> List.filter (fun n -> Grid.getString n map = "@")
    |> List.length

let solvePartOne input =
    let map = Grid.load input "." AdjacencyRule.Queen
    Grid.coords None map
    |> List.map (fun c -> countAdjacentRolls map c)
    |> List.filter (fun count -> count < 4)
    |> List.length

let solvePartTwo input =
    let mutable map = Grid.load input "." AdjacencyRule.Queen
    let mutable changeCount = -1
    let mutable removedCount = 0

    while changeCount <> 0 do
        let updatedMap = mkGrid "." AdjacencyRule.Queen
        changeCount <- 0

        Grid.coords None map
        |> List.map (fun c ->
            let count = countAdjacentRolls map c
            if count < 4 then do
                changeCount <- changeCount + 1
            else do
                Grid.setValue c (Glyph "@") updatedMap |> ignore )
        |> ignore

        map <- updatedMap
        removedCount <- removedCount + changeCount

    removedCount

let solveDay04 isTest: Unit =
    let day = 04
    let puzzleName = "Printing Department"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let solution1 = solvePartOne input
    printfn $"Part One: the number of accessible rolls is {solution1}"
    let solution2 = solvePartTwo input
    printfn $"Part Two: the number of removed rolls is {solution2}"

    printfn "All done."
