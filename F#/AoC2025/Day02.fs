[<AutoOpen>]
module Day02

open System.Text.RegularExpressions
open AoC.Util

let re1 = Regex(@"^(\d+)\1$")
let re2 = Regex(@"^(\d+)\1+$")


let valueOfId (id:int64) (re:Regex) =
    let idStr = string id
    if re.IsMatch(idStr) then id
    else 0


let solvePart  (ranges:list<(int64 * int64)>) (re:Regex) =
    ranges
    |> List.map (fun r -> 
        let a, b = r
        seq {a .. b}
        |> Seq.map (fun id -> valueOfId id re)
        |> Seq.sum)
    |> List.sum


let parseRanges (s:string) =
    s.Split(',')
    |> Array.map (fun (s:string) -> s.Split('-'))
    |> Seq.map (fun (arr:string array) -> (int64 arr[0], int64 arr[1]))
    |> Seq.toList


let solveDay02 isTest: Unit =
    let day = 02
    let puzzleName = "Unknown"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let ranges = parseRanges input.Head

    let solution1 = solvePart ranges re1
    printfn $"Part One: the sum of invalid ids is {solution1}"
    let solution2 = solvePart ranges re2
    printfn $"Part Two: the sum of invalid ids is {solution2}"

    printfn "All done."
