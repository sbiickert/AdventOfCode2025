[<AutoOpen>]
module Day01

open AoC.Util

let solvePartOne (input:list<int>): int =
    let mutable value = 50
    input
    |> List.fold (fun zeroCount num ->
        value <- (value + num) % 100
        if value = 0 then zeroCount + 1
        else zeroCount) 0

let solvePartTwo (input:list<int>): int =
    let mutable value = 50
    input
    |> List.fold (fun zeroCount num ->
        let step = num / abs num
        let mutable zc = 0
        
        for i = 1 to abs num do
            value <- (value + step) % 100
            if value = 0 then zc <- zc + 1

        zeroCount + zc) 0

let parseNumbers (lines:list<string>): list<int> =
    lines 
    |> List.map (fun (line:string) -> line.Replace('L', '-'))
    |> List.map (fun (line:string) -> line.Replace('R', ' '))
    |> List.map (fun (line:string) -> int line)

let solveDay01 isTest: Unit =
    let day = 1
    let puzzleName = "Testing"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let numbers = parseNumbers input

    let solution1 = solvePartOne numbers
    printfn $"Part One: {solution1}"
    let solution2 = solvePartTwo numbers
    printfn $"Part Two: {solution2}"

    printfn "All done."
