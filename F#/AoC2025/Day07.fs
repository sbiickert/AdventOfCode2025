[<AutoOpen>]
module Day07

open AoC.Util
open AoC.Geometry
open AoC.Grid

let solvePartOne manifold =
    let startCoord = (Grid.coords (Some "S") manifold).Head
    let mutable beams = [mkPos startCoord Direction.S]
    let mutable splitCount = 0

    while beams.Head.coord.y < manifold.extent.Value.max.y do
        let mutable newBeams = Set.empty
        beams
        |> List.iter (fun beam ->
            let movedBeam = Position.moveForward beam 2
            if Grid.getString movedBeam.coord manifold = "^" then
                newBeams <- newBeams.Add(mkPos (Coord.offset Direction.W 1 movedBeam.coord) movedBeam.dir)
                newBeams <- newBeams.Add(mkPos (Coord.offset Direction.E 1 movedBeam.coord) movedBeam.dir)
                splitCount <- splitCount + 1
            else
                newBeams <- newBeams.Add movedBeam
        )
        
        beams <- Set.toList newBeams

    splitCount

let solvePartTwo manifold =
    2

let solveDay07 isTest: Unit =
    let day = 07
    let puzzleName = "Laboratories"
    printfn $"Day {day}: {puzzleName}"
    let inputName = inputFileName day isTest
    let input = readInput inputName true

    let manifold = Grid.load input "." AdjacencyRule.Rook

    let solution1 = solvePartOne manifold
    printfn $"Part One: the number of times the beam is split is {solution1}"
    let solution2 = solvePartTwo manifold
    printfn $"Part Two: the total number of timelines is {solution2}"

    printfn "All done."
