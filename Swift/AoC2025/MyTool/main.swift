import Foundation

let s = Day06()
let i = AoCInput.inputsFor(solution: s)
var r = s.solve(i[0]) // 0 is challenge, 1 is first test group, etc.
print("\(r.description)")
