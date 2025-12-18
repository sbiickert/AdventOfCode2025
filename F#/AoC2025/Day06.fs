[<AutoOpen>]
module Day06

    module CephalopodMath =

        type Eq =
            {
                op: string
                values: string array2d
            }

        let getRowInt (eq:Eq) (row:int): int64 =
            eq.values.[*,row] |> String.concat "" |> int64

        let getColInt (eq:Eq) (col:int): int64 =
            eq.values.[col,*] |> String.concat "" |> int64

        let doAddP1 (eq:Eq): int64 =
            seq {0 .. Array2D.length2 eq.values - 1}
            |> Seq.map (fun i -> getRowInt eq i)
            |> Seq.sum
       
        let doMulP1 (eq:Eq): int64 =
            seq {0 .. Array2D.length2 eq.values - 1}
            |> Seq.map (fun i -> getRowInt eq i)
            |> Seq.fold (fun acc each -> acc * each) 1

        let execP1 (eq:Eq): int64 =
            match eq.op with
            | "+" -> doAddP1 eq
            | "*" -> doMulP1 eq
            | _ -> failwith "Bad operator"

        let doAddP2 (eq:Eq): int64 =
            seq {0 .. Array2D.length1 eq.values - 1}
            |> Seq.map (fun i -> getColInt eq i)
            |> Seq.sum
        
        let doMulP2 (eq:Eq): int64 =
            seq {0 .. Array2D.length1 eq.values - 1}
            |> Seq.map (fun i -> getColInt eq i)
            |> Seq.fold (fun acc each -> acc * each) 1

        let execP2 (eq:Eq): int64 =
            match eq.op with
            | "+" -> doAddP2 eq
            | "*" -> doMulP2 eq
            | _ -> failwith "Bad operator"

        let readEquations (lines:array<string>): list<Eq> =
            let y = lines.Length - 1
            let opIndexes = 
                lines[y] 
                |> Seq.mapi (fun i ch -> (i, string ch))
                |> Seq.filter (fun (i,s) -> s = "*" || s = "+")
                |> Seq.toArray
            let eqSizes =
                opIndexes
                |> Array.mapi (fun i (index,_) ->
                    if i < opIndexes.Length - 1 then
                        let nextIndex,_ = opIndexes[i+1]
                        nextIndex - index - 1
                    else
                        lines[y].Length - index
                    )
            opIndexes
            |> Array.mapi (fun i (index, op) ->
                let size = eqSizes[i]
                let arr = Array2D.create size y " "
                for col = 0 to size - 1 do
                    for row = 0 to y - 1 do
                        arr[col,row] <- string (lines[row][col+index])
                {op = op; values = arr})
            |> Array.toList

    [<AutoOpen>]
    module Solution = 
        open AoC.Util

        let solvePartOne equations =
            equations
            |> List.map CephalopodMath.execP1
            |> List.sum

        let solvePartTwo equations =
            equations
            |> List.map CephalopodMath.execP2
            |> List.sum

        let solveDay06 isTest: Unit =
            let day = 06
            let puzzleName = "Trash Compactor"
            printfn $"Day {day}: {puzzleName}"
            let inputName = inputFileName day isTest
            let input = readInput inputName true

            let equations = CephalopodMath.readEquations (input |> List.toArray)

            let solution1 = solvePartOne equations
            printfn $"Part One: the grand total of all answers is {solution1}"
            let solution2 = solvePartTwo equations
            printfn $"Part Two: the grand total of all answers is {solution2}"

            printfn "All done."
