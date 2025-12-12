[<AutoOpen>]
module Day05

open AoC.Util

let solvePartOne input =
    1

let solvePartTwo input =
    2

let solveDay05 isTest: Unit =
    let day = 05
    let puzzleName = "Cafeteria"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readGroupedInput inputName

    let solution1 = solvePartOne input
    printfn $"Part One: {solution1}"
    let solution2 = solvePartTwo input
    printfn $"Part Two: {solution2}"

    printfn "All done."
