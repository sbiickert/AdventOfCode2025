//
//  day04.swift
//  AoC2025
//

import Foundation

class Day04: AoCSolution {
	override init() {
		super.init()
		day = 4
		self.name = "Printing Department"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let grid = AoCGrid2D(defaultValue: ".", rule: .queen)
		grid.load(data: input.textLines)
		
		let p1 = removePaperRolls(in: grid, exhaustively: false)
		let p2 = removePaperRolls(in: grid, exhaustively: true) + p1
		
		return AoCResult(part1: "\(p1) rolls can be removed at first",
						 part2: "\(p2) rolls can be removed total")
	}
	
	func removePaperRolls(in grid:AoCGrid2D, exhaustively:Bool) -> Int {
		var removedCount = 0
		
		var removedThisRound = 1
		while removedThisRound > 0 {
			var removeCoords = [AoCCoord2D]()
			
			for c in grid.coords {
				let neighbors = grid.neighbourCoords(at: c, withValue: "@")
				
				if (neighbors.count < 4) {
					removeCoords.append(c)
				}
			}
			
			for removeCoord in removeCoords {
				grid.clear(at: removeCoord)
			}
			
			removedThisRound = removeCoords.count
			removedCount += removedThisRound;

			if !exhaustively { break }
		}
		
		return removedCount
	}
}

