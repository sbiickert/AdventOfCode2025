[<AutoOpen>]
module Day03

open Microsoft.FSharp.Collections
open AoC.Util

let maxJoltageForBankPartOne (bank:string): int64 =
    bank
    |> Seq.toList
    |> combinations 2
    |> List.map (fun pair -> System.String(List.toArray pair))
    |> List.map (fun s -> int64 s)
    |> List.max

let solvePartOne input =
    input
    |> List.map (fun bank -> maxJoltageForBankPartOne bank)
    |> List.sum

let maxJoltageForBankPartTwo (bank:string): int64 =
    1

let solvePartTwo input =
    input
    |> List.map (fun bank -> maxJoltageForBankPartTwo bank)
    |> List.sum

let solveDay03 isTest: Unit =
    let day = 03
    let puzzleName = "Lobby"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let solution1 = solvePartOne input
    printfn $"Part One: the sum of max joltage is (2 on) is {solution1}"
    let solution2 = solvePartTwo input
    printfn $"Part Two: the sum of max joltage is (12 on) is {solution2}"

    printfn "All done."
