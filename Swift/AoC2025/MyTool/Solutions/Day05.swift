//
//  day05.swift
//  AoC2025
//

import Foundation

class Day05: AoCSolution {
	override init() {
		super.init()
		day = 5
		self.name = "Cafeteria"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let groups = input.allInputGroups
		
		let ranges = parseRanges(groups.first ?? [])
		let ids = groups.last!.map({ Int($0) ?? -1 }).sorted()
		
		// Count the ids that are contained by a range
		let p1 = ids
			.map({id in
				ranges.contains(where: { $0.contains(id) }) })
			.count(where: { $0 == true })
		
		// Get the sum of the count of all ranges (because they are non-overlapping)
		let p2 = ranges.map({$0.count}).reduce(0, +)
		
		return AoCResult(part1: "The number of fresh ingredients is \(p1)", part2: "The total possible fresh ids is \(p2)")
	}
	
	func parseRanges(_ input:[String]) -> [ClosedRange<Int>] {
		var ranges = input.map { line in
			let parts = line.split(separator: "-").map { Int($0)! }
			return parts.first!...parts.last!
		}
		ranges.sort { $0.startIndex < $1.startIndex }
		
		// Coalesce the overlapping ranges
		var didCombine = true
		while didCombine {
			for i in 0..<ranges.count-1 {
				didCombine = false
				if ranges[i].upperBound >= ranges[i+1].lowerBound {
					let start = ranges[i].lowerBound
					let end = max(ranges[i].upperBound, ranges[i+1].upperBound)
					let combined = start...end
					ranges.remove(at: i+1)
					ranges[i] = combined
					didCombine = true
					break
				}
				continue
			}
		}
		
		return ranges
	}
}

