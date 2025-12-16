[<AutoOpen>]
module Day05

open AoC.Util
open AoC.Geometry

let solvePartOne (freshRanges:list<Range>) (ingredientIDs:list<int64>) =
    ingredientIDs
    |> List.filter (fun id ->
        freshRanges |> List.exists (fun rng -> Range.contains rng id))
    |> List.length

let solvePartTwo (freshRanges:list<Range>) =
    let mutable uniqueRanges = freshRanges |> List.sortBy (fun rng -> rng.lo) |> List.toArray
    let mutable rangeCount = -1
    while uniqueRanges.Length <> rangeCount do
        rangeCount <- uniqueRanges.Length
        for i = 0 to uniqueRanges.Length - 2 do
            let mutable shortCircuit = false
            for j = i + 1 to uniqueRanges.Length - 1 do
                if shortCircuit |> not then
                    if uniqueRanges[i].hi < uniqueRanges[j].lo then
                        shortCircuit <- true
                    elif (Range.intersect uniqueRanges[i] uniqueRanges[j]).IsSome then
                        let sum = Range.add uniqueRanges[i] uniqueRanges[j]
                        uniqueRanges[i] <- sum
                        uniqueRanges[j] <- {lo = 0; hi = -1} // isValid = false
                        uniqueRanges <- uniqueRanges |> Array.filter Range.isValid
                        shortCircuit <- true

    uniqueRanges |> Array.map Range.sizeOf |> Array.sum

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
    let solution2 = solvePartTwo freshRanges
    printfn $"Part Two: the total number of potential fresh ids is {solution2}"

    printfn "All done."
