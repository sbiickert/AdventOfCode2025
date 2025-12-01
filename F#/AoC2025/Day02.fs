[<AutoOpen>]
module Day02

open AoC.Util

let solvePartOne input =
    1

let solvePartTwo input =
    2

let solveDay02 isTest: Unit =
    let day = 02
    let puzzleName = "Unknown"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let solution1 = solvePartOne input
    let solution2 = solvePartTwo input

    printfn "All done."
