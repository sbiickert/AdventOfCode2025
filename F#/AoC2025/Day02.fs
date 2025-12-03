[<AutoOpen>]
module Day02

open System.Text.RegularExpressions
open AoC.Util

let re1 = Regex(@"^(\d+)\1$")
let re2 = Regex(@"^(\d+)\1+$")

let valueOfIdPartOne (id:int64) =
    let idStr = string id
    if re1.IsMatch(idStr) then id
    else 0
    
let solvePartOne (ranges:list<(int64 * int64)>) =
    ranges
    |> List.map (fun r -> 
        let (a, b) = r
        seq {a .. b }
        |> Seq.map (fun id -> valueOfIdPartOne id)
        |> Seq.sum
    )
    |> List.sum

let valueOfIdPartTwo (id:int64) =
    let idStr = string id
    if re2.IsMatch(idStr) then id
    else 0

let solvePartTwo  (ranges:list<(int64 * int64)>) =
    ranges
    |> List.map (fun r -> 
        let (a, b) = r
        seq {a .. b }
        |> Seq.map (fun id -> valueOfIdPartTwo id)
        |> Seq.sum
    )
    |> List.sum

let solveDay02 isTest: Unit =
    let day = 02
    let puzzleName = "Unknown"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let ranges = 
        input.Head.Split(',')
        |> Array.map (fun (s:string) -> s.Split('-'))
        |> Seq.map (fun (arr:string array) -> (int64 arr[0], int64 arr[1]))
        |> Seq.toList

    let solution1 = solvePartOne ranges
    printfn $"Part One: the sum of invalid ids is {solution1}"
    let solution2 = solvePartTwo ranges
    printfn $"Part Two: the sum of invalid ids is {solution2}"

    printfn "All done."
