[<AutoOpen>]
module Day05

open AoC.Util
open AoC.Geometry

let solvePartOne (freshRanges:list<Range>) (ingredientIDs:list<int64>) =
    ingredientIDs
    |> List.filter (fun id ->
        freshRanges |> List.exists (fun rng -> Range.contains rng id))
    |> List.length

let solvePartTwo input =
    2

let parseIngredientRanges lines =
    lines
    |> List.map (fun (line:string) -> line.Split "-")
    |> List.map (fun strs -> mkRange (int64 strs[0]) (int64 strs[1]))

let solveDay05 isTest: Unit =
    let day = 05
    let puzzleName = "Cafeteria"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readGroupedInput inputName

    let freshRanges = parseIngredientRanges input.Head
    let ingredientIDs = input[1] |> List.map int64

    let solution1 = solvePartOne freshRanges ingredientIDs
    printfn $"Part One: the number of fresh ingredients is {solution1}"
    let solution2 = solvePartTwo input
    printfn $"Part Two: {solution2}"

    printfn "All done."
