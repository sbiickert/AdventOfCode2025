//
//  day03.swift
//  AoC2025
//

import Foundation

class Day03: AoCSolution {
	override init() {
		super.init()
		day = 3
		self.name = "Lobby"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let joltages = input.textLines.map { line in
			AoCUtil.numberToIntArray(line)
		}
		
		let p1 = solvePart(joltages, count: 2)
		let p2 = solvePart(joltages, count: 12)

		return AoCResult(part1: "Total joltage with 2 batteries is \(p1)",
						 part2: "Total joltage with 12 batteries is \(p2)")
	}
	
	func solvePart(_ joltages:[[Int]], count:Int) -> Int {
		let result = joltages.map({ select(best: count, in: $0) }).reduce(0, +)
		return result
	}
	
	func select(best count:Int, in joltages:[Int]) -> Int {
		var work = joltages;
		while (work.count > count) {
			var removeIndex = -1
			for i in 0..<work.count {
				var diff = 0
				if (i < work.count-1) { diff = work[i] - work[i+1] }
				if diff < 0 {
					removeIndex = i
					break
				}
			}
			if removeIndex < 0 {
				work.removeLast()
			}
			else {
				work.remove(at: removeIndex)
			}
		}
		
		let result = AoCUtil.joinDigits(work)
		return result
	}
}

