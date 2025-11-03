[<AutoOpen>]
module Day00

open AoC.Util

let solveDay00 isTest: Unit =
    let puzzleName = "Testing"
    printfn $"Day 00: {puzzleName}"
    let inputName = inputFileName 0 isTest
    let input = readGroupedInput inputName
    printfn "All done."
