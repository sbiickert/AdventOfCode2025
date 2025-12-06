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

let indexToDrop (batteries:list<int>): int =
    let mutable result = -1
    let len = List.length batteries

    for i = 0 to len - 1 do
        if result >= 0 then
            ()
        elif i + 1 = len then
            result <- i
        elif batteries[i] < batteries[i+1] then
            result <- i
            
    result

let maxJoltageForBankPartTwo (bank:string): int64 =
    let mutable batteries = 
        bank
        |> Seq.map (fun c -> int (string c)) 
        |> Seq.toList

    while List.length batteries > 12 do
        let dropI = indexToDrop batteries
        batteries <- batteries
        |> List.mapi (fun index n -> (index <> dropI, n))
        |> List.filter fst
        |> List.map snd
        
    batteries
    |> List.map (fun i -> string i)
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
