//
//  day02.swift
//  AoC2025
//

import Foundation

class Day02: AoCSolution {
	override init() {
		super.init()
		day = 2
		self.name = "Gift Shop"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let ranges = parseIdRanges(input: input.textLines.first!)
		let p1 = solvePartOne(ranges)
		let p2 = solvePartTwo(ranges)
		return AoCResult(part1: "The sum of invalid ids is \(p1)", part2: "The sum of invalid ids is \(p2)")
	}
	
	func solvePartOne(_ ranges:[ClosedRange<Int>]) -> Int {
		let pattern = "^(\\d+)\\1$"
		return summarizeInvalidIDs(in: ranges, matching: pattern)
	}
	
	func solvePartTwo(_ ranges:[ClosedRange<Int>]) -> Int {
		let pattern = "^(\\d+)(\\1{1,})$"
		return summarizeInvalidIDs(in: ranges, matching: pattern)
	}

	func summarizeInvalidIDs(in ranges:[ClosedRange<Int>], matching pattern: String) -> Int {
		let regex = try! Regex(pattern)
		var count = 0;
		
		for range in ranges {
			for i in range {
				let s:String = String(i)
				if s.firstMatch(of: regex) != nil {
					count += i
				}
			}
		}
		
		return count
	}
	
	func parseIdRanges(input: String) -> [ClosedRange<Int>] {
		var result = [ClosedRange<Int>]()
		let strings = input.split(separator: ",")
		for s in strings {
			let numStrings = s.split(separator: "-")
			let nums:[Int] = numStrings.map { Int($0) ?? -1 }
			result.append(nums.first!...nums.last!)
		}
		
		return result
	}
}

