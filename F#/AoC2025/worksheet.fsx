#load "AoCUtil.fs"
// #load "AoCGeometry.fs"
// #load "AoCGrid.fs"

// #load "Day02.fs"
// #time
// solveDay02 false |> ignore
// #time

let input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
input.Split("do()")
|> Array.map (fun (s:string) -> s.Split("don't()")[0])