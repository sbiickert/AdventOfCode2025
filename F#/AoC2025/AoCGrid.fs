namespace AoC

open AoC.Util
open AoC.Geometry

module Grid =

    type GridData = 
        | Glyph of glyph: string
        | Value of value: int64
        | Complex of glyph: string * value:obj

    type Grid =
        {
            data: Map<Coord, GridData>
            extent: Extent option
            rule: AdjacencyRule
            defaultValue: string
        }

    let mkGrid defaultValue rule =
        {data = Map.empty; extent = None; rule = rule; defaultValue = defaultValue}
       
    let getValue grid coord = 
        if grid.data.ContainsKey coord then
            grid.data.Item coord
        else
            Glyph grid.defaultValue
    
    let getString grid coord =
        if grid.data.ContainsKey coord then
            let d = grid.data.Item coord
            match d with
            | Glyph g -> g
            | Value i -> i.ToString()
            | Complex (glyph, _) -> glyph
        else
            grid.defaultValue

    let setValue grid coord value =
        let newData = grid.data.Add (coord,value)
        
        let newExtent = 
            if grid.extent.IsNone then
                mkExtent [coord]
            else
                Extent.expandToFit grid.extent.Value [coord]
        {grid with data = newData; extent = Some(newExtent)}

    let loadGrid (input: string list) defaultValue rule =
        let mutable grid = mkGrid defaultValue rule

        let yseq = seq { for y in [0 .. input.Length-1] -> (y, input[y]) }
        for (y, line) in yseq do
            let chars = Seq.toList line |> List.map (fun c -> c.ToString())
            let xseq = seq { for x in [0 .. chars.Length-1] -> (x, chars[x]) }
            for (x, c) in xseq do
                if c <> grid.defaultValue then
                    grid <- setValue grid {x = x; y = y} (Glyph c)
        grid
    
    let clear grid coord resetExtent =
        let newData = grid.data.Remove coord

        let newExtentOpt = 
            if resetExtent then
                let coords = List.ofSeq newData.Keys
                Some(mkExtent coords)
            else
                grid.extent
        {grid with data = newData; extent = newExtentOpt}
    
    let coords grid (withValue: string option) =
        if withValue.IsNone then
            List.ofSeq grid.data.Keys
        else
            let value = withValue.Value
            grid.data.Keys
            |> Seq.filter (fun coord -> getString grid coord = value)
            |> List.ofSeq
    
    let histogram grid includeUnset: Map<string,int> =
        if grid.extent.IsNone then Map.empty
        else
            let ext = grid.extent.Value
            let coordsToSum =
                if includeUnset then
                    Extent.allCoordsIn ext
                else
                    coords grid None

            coordsToSum
            |> List.map (fun coord -> getString grid coord)
            |> AoC.Util.frequencyMap

    let neighbors grid coord =
        Coord.adjacentCoords coord grid.rule

    let sprintGrid (grid:Grid) (markers:Map<Coord,string> option) =
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
                        getString grid coord
                else
                    "\n")
            |> List.fold (+) ""

    let printGrid grid (markers:Map<Coord,string> option) =
        let str = sprintGrid grid markers
        printfn $"{str}"

