//
//  Day07.swift
//  AoC2025
//

import Foundation

class Day07: AoCSolution {
	override init() {
		super.init()
		day = 7
		self.name = "Laboratories"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		// No need for the lines with no data
		let filteredInput = input.textLines.enumerated().compactMap({ line in
			if line.element.contains(/[S^]/) {
				return line.element
			}
			return nil
		})
		
		let grid = AoCGrid2D(defaultValue: ".", rule: .queen)
		grid.load(data: filteredInput)
		
		let (p1,p2) = shootBeam(in: grid)
				
		return AoCResult(part1: "The number of splits is \(p1)", part2: "The number of universes is \(p2)")
	}
	
	func shootBeam(in grid:AoCGrid2D) -> (Int,Int) {
		var splitCount = 0

		let start = grid.getCoords(withValue: "S").first!
		var ext = grid.extent!
		grid.setValue(1, at: start)
		
		for y in start.y...ext.max.y {
			for x in ext.min.x...ext.max.x {
				let c = AoCCoord2D(x: x, y: y)
				if let i = Int(grid.stringValue(at: c)) {
					let down = c.offset(direction: .south)
					if grid.stringValue(at: down) == "^" {
						// Split
						splitCount += 1
						addValue(i, in: grid, at: c.offset(direction: .sw))
						addValue(i, in: grid, at: c.offset(direction: .se))
					}
					else {
						// Add to down
						addValue(i, in: grid, at: down)
					}
				}
			}
		}
		
		// Add up the values in the bottom row
		var values = [Int]()
		ext = grid.extent! // Have appended a row, refresh ext
		for x in ext.min.x...ext.max.x {
			if let v = Int(grid.stringValue(at: AoCCoord2D(x: x, y: ext.max.y))) {
				values.append(v)
			}
		}
		
		return (splitCount, values.reduce(0, +))
	}
	
	func addValue(_ value:Int, in grid:AoCGrid2D, at coord:AoCCoord2D) {
		if let i = Int(grid.stringValue(at: coord)) {
			grid.setValue(value + i, at: coord)
		}
		else {
			grid.setValue(value, at: coord)
		}
	}
}

