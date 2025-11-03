namespace AoC

module Util = 
    let inputPath = 
        if System.Environment.OSVersion.Platform = System.PlatformID.Unix then
            "/Users/sjb/Developer/Advent of Code/2025/AdventOfCode2025/Input/"
        else
            """C:\Users\sjb\source\repos\sbiickert\AdventOfCode2025\Input\"""

    let inputFileName (day:int) isTest =
        let dayStr = sprintf "%02d" day
        if isTest then
            $"{inputPath}day{dayStr}_test.txt"
        else
            $"{inputPath}day{dayStr}_challenge.txt"

    let readInput fileName removeEmptyLines =
        let lines  = System.IO.File.ReadLines(fileName)
        if removeEmptyLines then
            Seq.filter (fun line -> line.ToString().Length > 0) lines |> Seq.toList
        else
            Seq.toList lines

    let readGroupedInput fileName =
        let lines = readInput fileName false
        let result = ResizeArray()
        let group = ResizeArray<string>()
        for line in lines do
            if line.Length = 0 then
                let list = Seq.toList group
                result.Add list
                group.RemoveAll (fun str -> str.Length > 0)
            else
                group.Add line
                1
            |> ignore

        if group.Count > 0 then
            let list = Seq.toList group
            result.Add list

        Seq.toList result
    
    let gcd (x: int64) (y: int64) =
        let mutable a = 0L
        let mutable b = max x y
        let mutable r = min x y
        while r <> 0 do
            a <- b
            b <- r
            r <- a % b
        b
    
    let rec lcm (values: list<int64>) =
        match values.Length with
        | 0 -> 0L
        | 1 -> values.Head
        | _ ->
            let next = values.Tail.Head
            let g = gcd values.Head next
            let running = values.Head / g * next
            let nextValues = running :: values.Tail.Tail
            lcm nextValues
    
    let cartesian aList bList =
        List.collect (fun a -> List.map (fun b ->  a,b) bList) aList

    let pivotMatrix<'T>(source:list<list<'T>>): list<list<'T>> =
        let pivot = ResizeArray<ResizeArray<'T>>()
        for _ in [0 .. source.Head.Length-1] do
            let row = ResizeArray<'T>()
            pivot.Add row

        for row in source do
            let mutable col = 0
            for value in row do
                (pivot.Item col).Add value
                col <- col + 1
        
        pivot
        |> Seq.map (fun row -> List.ofArray(row.ToArray()))
        |> Seq.toList

    let frequencyMap source =
        source
        |> Seq.groupBy id
        |> Seq.map (fun (c, cs) -> c, Seq.length cs)
        |> Map

    let approxEqual (tolerance:double) d1 d2 =
        abs(d1-d2) < tolerance

    // For unit testing
    let assertEqual a b =
        if a <> b then failwith $"Value '{a}' does not equal '{b}'."

    let assertTrue a =
        if a <> true then failwith $"Assertion was not true."
        
    let assertFalse a =
        if a <> false then failwith $"Assertion was not false."