[<AutoOpen>]
module Day08

open AoC.Util
open AoC.Geometry

let findCircuitIndex circuits jbox =
    circuits
    |> List.mapi (fun i circuit -> if Set.contains jbox circuit then i else -1)
    |> List.filter (fun i -> i >= 0)
    |> List.head

let mergedCircuits jbox1 jbox2 circuits =
    let index1 = findCircuitIndex circuits jbox1
    let index2 = findCircuitIndex circuits jbox2
    if index1 = index2 then circuits
    else
        let mergedCircuit = Set.union circuits[index1] circuits[index2]
        circuits 
        |> List.indexed 
        |> List.filter (fun (i, circuit) -> i <> index1 && i <> index2)
        |> List.map snd
        |> List.append [mergedCircuit]


let solvePartOne isTest jboxes =
    let mutable circuits = jboxes |> List.map (fun jbox -> Set.ofList [jbox])

    let mutable distances = 
        AoC.Util.combinations 2 jboxes
            |> List.map (fun combo -> (Coord.distance combo[0] combo[1]), combo)
            |> List.sortBy (fun (dist, _) -> dist)

    let iterCount = if isTest then 10 else 1000
    seq { 1 .. iterCount } |> Seq.iter (fun i -> 
        let (dist, combo) = distances.Head
        distances <- distances.Tail
        circuits <- mergedCircuits combo[0] combo[1] circuits
    )

    circuits
    |> List.map Set.count
    |> List.sortDescending
    |> List.take 3
    |> List.fold (fun each acc -> each * acc) 1

let solvePartTwo jboxes =
    let mutable circuits = jboxes |> List.map (fun jbox -> Set.ofList [jbox])

    let mutable distances = 
        AoC.Util.combinations 2 jboxes
            |> List.map (fun combo -> (Coord.distance combo[0] combo[1]), combo)
            |> List.sortBy (fun (dist, _) -> dist)

    let mutable result = 0L
    while result = 0L do
        let (dist, combo) = distances.Head
        circuits <- mergedCircuits combo[0] combo[1] circuits
        if result = 0 && circuits.Length = 1 then
            result <- combo[0].x * combo[1].x 
        distances <- distances.Tail

    result


let solveDay08 isTest: Unit =
    let day = 08
    let puzzleName = "Playground"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input:list<string> = readInput inputName true

    let jboxes =
        input
        |> List.map (fun line -> line.Split "," |> Array.map int64)
        |> List.map (fun arr -> mkCoord3 arr[0] arr[1] arr[2])

    let solution1 = solvePartOne isTest jboxes
    printfn $"Part One: {solution1}"
    let solution2 = solvePartTwo jboxes
    printfn $"Part Two: {solution2}"

    printfn "All done."
