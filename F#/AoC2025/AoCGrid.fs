namespace AoC

open System.Collections.Generic
open AoC.Util
open AoC.Geometry

module Grid =

    type GridData = 
        | Glyph of glyph: string
        | Value of value: int64
        | Complex of glyph: string * value:obj

    type Grid =
        {
            data: Dictionary<Coord, GridData>
            extent: Extent option
            rule: AdjacencyRule
            defaultValue: string
        }

    let mkGrid defaultValue rule =
        {data = new Dictionary<Coord, GridData>(); extent = None; rule = rule; defaultValue = defaultValue}
    
    module Grid =
        let getValue coord grid = 
            if grid.data.ContainsKey coord then
                grid.data.Item coord
            else
                Glyph grid.defaultValue
        
        let getString coord grid =
            if grid.data.ContainsKey coord then
                let d = grid.data.Item coord
                match d with
                | Glyph g -> g
                | Value i -> i.ToString()
                | Complex (glyph, _) -> glyph
            else
                grid.defaultValue

        let getInteger coord grid = 
            let gridData = getValue coord grid
            match gridData with
            | Value i -> i
            | Glyph g -> int64 g
            | _ -> 0 

        let setValue coord value grid = 
            if grid.data.ContainsKey coord then
                grid.data.Remove coord |> ignore
            grid.data.Add (coord,value)
            
            let newExtent = 
                if grid.extent.IsNone then
                    mkExtent [coord]
                else
                    Extent.expandToFit grid.extent.Value [coord]
            {grid with extent = Some newExtent}

        let batchUpdate (data:Map<Coord,GridData option>) grid =
            data
            |> Map.map (fun coord value ->
                grid.data.Remove coord |> ignore
                if data[coord].IsSome then
                    grid.data.Add (coord,value.Value)
                )
            |> ignore

        let copy grid =
            let clonedData = new Dictionary<Coord, GridData>()
            for coord in grid.data.Keys do
                clonedData.Add(coord,grid.data.Item coord)
            {grid with data=clonedData; extent=grid.extent; rule=grid.rule; defaultValue=grid.defaultValue}

        let load (input: string list) defaultValue rule =
            let mutable grid = mkGrid defaultValue rule

            let yseq = seq { for y in [0 .. input.Length-1] -> (y, input[y]) }
            for (y, line) in yseq do
                let chars = Seq.toList line |> List.map (fun c -> c.ToString())
                let xseq = seq { for x in [0 .. chars.Length-1] -> (x, chars[x]) }
                for (x, c) in xseq do
                    if c <> grid.defaultValue then
                        grid <- setValue {x = x; y = y} (Glyph c) grid
            grid
        
        let clear coord resetExtent grid =
            let removeSuccessful = grid.data.Remove coord

            let newExtentOpt = 
                if resetExtent && removeSuccessful then
                    let coords = List.ofSeq grid.data.Keys
                    Some(mkExtent coords)
                else
                    grid.extent
            {grid with extent = newExtentOpt}
        
        let coords (withValue: string option) grid =
            if withValue.IsNone then
                List.ofSeq grid.data.Keys
            else
                let value = withValue.Value
                grid.data.Keys
                |> Seq.filter (fun coord -> getString coord grid = value)
                |> List.ofSeq
        
        let histogram includeUnset grid: Map<string,int> =
            if grid.extent.IsNone then Map.empty
            else
                let ext = grid.extent.Value
                let coordsToSum =
                    if includeUnset then
                        Extent.allCoordsIn ext
                    else
                        coords None grid

                coordsToSum
                |> List.map (fun coord -> getString coord grid)
                |> AoC.Util.frequencyMap

        let neighbors coord grid =
            Coord.adjacentCoords coord grid.rule

        let sprint (markers:Map<Coord,string> option) (grid:Grid) =
            if grid.extent.IsNone then ""
            else
                let ext = grid.extent.Value
                cartesian [ext.min.y .. ext.max.y] [ext.min.x .. ext.max.x+1L] // +1 to extend outside ext
                |> List.map (fun (y, x) -> mkCoord x y)
                |> List.map (fun coord -> 
                    if Extent.contains ext coord then
                        if markers.IsSome && markers.Value.ContainsKey coord then
                            markers.Value.Item coord
                        else
                            getString coord grid
                    else
                        "\n")
                |> List.fold (+) ""

        let print (markers:Map<Coord,string> option) (grid:Grid) =
            let str = sprint markers grid
            printfn $"{str}"

