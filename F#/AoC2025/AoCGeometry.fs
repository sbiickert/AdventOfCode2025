namespace AoC

module Geometry =

    type Coord =
        {
            x: int64
            y: int64
        }

    type AdjacencyRule =
        | Rook
        | Bishop
        | Queen

    type Direction =
        | N
        | NE
        | E
        | SE
        | S
        | SW
        | W
        | NW

    type RotationDirection =
        | CW
        | CCW

    type Position = 
        {
            coord: Coord
            dir: Direction
        }

    type Segment =
        {
            a: Coord
            b: Coord
        }

    type Extent =
        {
            min: Coord
            max: Coord
        }

    let mkCoord (x:int64) (y:int64) =
        {x = x; y = y}

    let mkPos coord dir =
        {coord = coord; dir = dir}
    
    let mkSeg coordFrom coordTo =
        {a = coordFrom; b = coordTo}

    let rec expandExtentToFit ext (coords: list<Coord>) =
            if coords.IsEmpty then ext
            else
                let minX = min ext.min.x coords.Head.x
                let minY = min ext.min.y coords.Head.y
                let newMin = mkCoord minX minY
                let maxX = max ext.max.x coords.Head.x
                let maxY = max ext.max.y coords.Head.y
                let newMax = mkCoord maxX maxY
                let expanded = {min = newMin; max = newMax}
                expandExtentToFit expanded coords.Tail

    let mkExtent (coords: list<Coord>) =
        let ext = {min = coords.Head; max = coords.Head}
        expandExtentToFit ext coords.Tail

    let mkExtI minX minY maxX maxY =
        mkExtent [mkCoord minX minY; mkCoord maxX maxY]

    module Direction =
        let offset (d:Direction) =
            match d with
            | Direction.N  -> {x =  0; y = -1}
            | Direction.NE -> {x =  1; y = -1}
            | Direction.E  -> {x =  1; y =  0}
            | Direction.SE -> {x =  1; y =  1}
            | Direction.S  -> {x =  0; y =  1}
            | Direction.SW -> {x = -1; y =  1}
            | Direction.W  -> {x = -1; y =  0}
            | Direction.NW -> {x = -1; y = -1}
        
        let fromString (dir:string) =
            match dir.ToUpper() with
            | "NE" -> Some(Direction.NE)
            | "SE" -> Some(Direction.SE)
            | "SW" -> Some(Direction.SW)
            | "NW" -> Some(Direction.NW)
            | "E" | ">" | "R"  -> Some(Direction.E)
            | "S" | "V" | "D"  -> Some(Direction.S)
            | "W" | "<" | "L"  -> Some(Direction.W)
            | "N" | "^" | "U"  -> Some(Direction.N)
            | _ -> None

        let directionsFor rule = 
            if rule = AdjacencyRule.Rook then [Direction.N; Direction.E; Direction.S; Direction.W]
            elif rule = AdjacencyRule.Bishop then [Direction.NE; Direction.SE; Direction.SW; Direction.NW]
            else
                [Direction.N; Direction.NE; Direction.E; Direction.SE; 
                Direction.S; Direction.SW; Direction.W; Direction.NW]

    module Coord =
        let origin = mkCoord 0 0 

        let add a b =
            {x = a.x + b.x; y = a.y + b.y}
        
        let delta a b =
            {x = b.x - a.x; y = b.y - a.y}

        let manhattanDistance a b =
            abs(a.x - b.x) + abs(a.y - b.y)

        let distance a b =
            let del = delta a b
            sqrt (double del.x ** 2 + double del.y ** 2)

        let offset dir (size: int64) a =
            let off = Direction.offset dir
            if size = 0 then a
            elif size = 1 then add a off
            else
                let bigOffset = {x = off.x * size; y = off.y * size}
                add a bigOffset
        
        let areAdjacent a b (rule:AdjacencyRule) =
            match rule with
            | AdjacencyRule.Rook -> manhattanDistance a b = 1
            | AdjacencyRule.Bishop -> abs(a.x - b.x) = 1 && abs(a.y - b.y) = 1
            | AdjacencyRule.Queen -> manhattanDistance a b = 1 || (abs(a.x - b.x) = 1 && abs(a.y - b.y) = 1)

        let adjacentCoords c (rule:AdjacencyRule) =
            let adjacent =
                Direction.directionsFor rule
                |> List.map (fun dir -> Direction.offset dir)
                |> List.map (fun off -> add c off)
            adjacent

    module Position =
        let turn pos rotationDir =
            let ordered = Direction.directionsFor AdjacencyRule.Rook
            let index = List.findIndex (fun d -> d = pos.dir) ordered
            let turnedIndex = 
                if rotationDir = RotationDirection.CW then
                    (index + 1) % 4
                else
                    (index - 1) % 4
            {coord = pos.coord; dir = ordered[turnedIndex]}

        let turnWithString pos (rotationStr: string) =
            match rotationStr.ToUpper() with
            | "CW" | "R" -> turn pos RotationDirection.CW
            | "CCW" | "L" -> turn pos RotationDirection.CCW
            | _ -> pos

        let moveForward pos (distance: int64) =
            let off = Direction.offset pos.dir
            let move = {x = off.x * distance; y = off.y * distance}
            let nextPos = Coord.add pos.coord move
            mkPos nextPos pos.dir
    
    module Segment =
        let length seg = 
            Coord.manhattanDistance seg.a seg.b
        
        let isHorizontal seg = 
            seg.a.y = seg.b.y && seg.a.x <> seg.b.x
        
        let isVertical seg =
            seg.a.x = seg.b.x && seg.a.y <> seg.b.y
    
        let direction seg =
            if length seg = 0 then Direction.N
            elif isHorizontal seg then
                if seg.a.x < seg.b.x then Direction.E
                else Direction.W
            elif isVertical seg then
                if seg.a.y < seg.b.y then Direction.S
                else Direction.N
            elif seg.a.x < seg.b.x then
                if seg.a.y < seg.b.y then Direction.SE
                else Direction.NE
            else
                if seg.a.y < seg.b.y then Direction.SW
                else Direction.NW
                
    module Extent =
        let isValid ext =
            ext.min.x <= ext.max.x && ext.min.y <= ext.max.y

        let expandToFit ext (coords: list<Coord>) =
            expandExtentToFit ext coords
        
        let NW ext = ext.min
        let NE ext = {x = ext.max.x; y = ext.min.y}
        let SE ext = ext.max
        let SW ext = {x = ext.min.x; y = ext.max.y}

        let widthOf (ext:Extent) = ext.max.x - ext.min.x + 1L
        let heightOf (ext:Extent) = ext.max.y - ext.min.y + 1L
        let areaOf (ext:Extent) = 
            let w = widthOf ext 
            let h = heightOf ext
            w * h 
        
        let allCoordsIn ext =
            let xs = [ext.min.x .. ext.max.x]
            let ys = [ext.min.y .. ext.max.y]
            // ys first for reading order
            AoC.Util.cartesian ys xs
            |> List.map (fun (y, x) -> mkCoord x y)
        
        let contains ext coord =
            ext.min.x <= coord.x && coord.x <= ext.max.x && ext.min.y <= coord.y && coord.y <= ext.max.y
        
        let inset ext inset =
            mkExtI (ext.min.x + inset)  (ext.min.y + inset) 
                (ext.max.x - inset)  (ext.max.y - inset)
            
        let intersect ext1 ext2 =
            let commonMinX = max ext1.min.x ext2.min.x
            let commonMaxX = min ext1.max.x ext2.max.x
            let commonMinY = max ext1.min.y ext2.min.y
            let commonMaxY = min ext1.max.y ext2.max.y
            if commonMaxX < commonMinX then None
            elif commonMaxY < commonMinY then None
            else Some(mkExtI commonMinX commonMinY commonMaxX commonMaxY)

        let union ext1 ext2 =
            let intersectResult = intersect ext1 ext2
            if ext1 = ext2 then [ext1]
            elif intersectResult.IsNone then [ext1; ext2]
            else
                let mResult = ResizeArray<Extent>()
                let eInt = intersectResult.Value
                mResult.Add eInt

                for e in [ext1; ext2] do
                    if e <> eInt then
                        //There are eight "edges" & "corners"
                        // West edge
                        let nwToW = NW eInt |> Coord.offset Direction.W 1
                        if contains e nwToW then
                            let newE = mkExtI (NW e).x (NW eInt).y ((NW eInt).x-1L) (SW eInt).y
                            mResult.Add newE
                        // NW corner
                        let nwToNW = NW eInt |> Coord.offset Direction.NW 1
                        if contains e nwToNW  then
                            let newE = mkExtI (NW e).x (NW e).y ((NW eInt).x-1L) ((NW eInt).y-1L)
                            mResult.Add newE
                        // North edge
                        let nwToN = NW eInt |> Coord.offset Direction.N 1
                        if contains e nwToN then
                            let newE = mkExtI (NW eInt).x (NW e).y (NE eInt).x ((NE eInt).y-1L)
                            mResult.Add newE
                        // NE corner
                        let neToNE = NE eInt |> Coord.offset Direction.NE 1
                        if contains e neToNE then
                            let newE = mkExtI ((NE eInt).x+1L) (NE e).y (SE e).x ((NE eInt).y-1L)
                            mResult.Add newE
                        // East edge
                        let seToE = SE eInt |> Coord.offset Direction.E 1
                        if contains e seToE then
                            let newE = mkExtI ((SE eInt).x+1L) (NE eInt).y (SE e).x (SE eInt).y
                            mResult.Add newE
                        // SE corner
                        let seToSE = SE eInt |> Coord.offset Direction.SE 1
                        if contains e seToSE then
                            let newE = mkExtI ((SE eInt).x+1L) ((SE eInt).y+1L) (SE e).x (SE e).y
                            mResult.Add newE
                        // South edge
                        let seToS = SE eInt |> Coord.offset Direction.S 1
                        if contains e seToS then
                            let newE = mkExtI (SW eInt).x ((SW eInt).y+1L) (SE eInt).x (SW e).y
                            mResult.Add newE
                        // SW corner
                        let swToSW = SW eInt |> Coord.offset Direction.SW 1
                        if contains e swToSW then
                            let newE = mkExtI (SW e).x ((SW eInt).y+1L) ((SW eInt).x-1L) (SW e).y
                            mResult.Add newE
                Seq.toList mResult

