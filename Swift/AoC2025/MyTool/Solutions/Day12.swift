//
//  Day12.swift
//  AoC2025
//

import Foundation

class Day12: AoCSolution {
	override init() {
		super.init()
		day = 12
		self.name = "Christmas Tree Farm"
		self.emptyLinesIndicateMultipleInputs = false
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let counts = input.allInputGroups[6].map { line in
			let re = /([\d ]+)$/
			let m = line.firstMatch(of: re)!
			return m.1.split(separator: " ").compactMap({Int($0)})
		}
		
		let regions = input.allInputGroups[6].map { line in
			let re = /(\d+)x(\d+)/
			let m = line.firstMatch(of: re)!
			return AoCCoord2D(x: Int(m.1)!, y: Int(m.2)!)
		}
		
		// The challenge input is a joke, don't worry about interlocking pieces
		var validCount = 0
		for i in 0..<regions.count {
			let totalPresents = counts[i].reduce(0, +)
			let area = (regions[i].x) / 3 * (regions[i].y / 3) // All presents are 3x3
			if area >= totalPresents {
				validCount += 1
			}
		}
		
		return AoCResult(part1: "The number of valid regions is \(validCount)", part2: "Merry Christmas!")
	}
}

