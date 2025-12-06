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

// https://www.reddit.com/r/adventofcode/comments/1pdk5zj/2025_day_3_part_2_python_am_i_misunderstanding/

let indexToDrop (batteries:array<int>): int =
    let mutable result = -1
    let len = Array.length batteries

    for i = 0 to len - 1 do
        if result >= 0 then
            () // No-Op, using since there isn't a break in F#
        elif i + 1 = len then
            result <- i // Last battery in the bank
        elif batteries[i] < batteries[i+1] then
            result <- i // Represents a step up from this number to the next
            
    result

let maxJoltageForBankPartTwo (bank:string): int64 =
    let mutable batteries = 
        bank
        |> Seq.map (fun c -> int (string c)) 
        |> Seq.toArray

    while Array.length batteries > 12 do
        let dropI = indexToDrop batteries
        batteries <- batteries
        |> Array.mapi (fun index n -> (index <> dropI, n))
        |> Array.filter fst
        |> Array.map snd
        
    batteries
    |> Array.map (fun i -> string i)
    |> String.concat ""
    |> int64

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
