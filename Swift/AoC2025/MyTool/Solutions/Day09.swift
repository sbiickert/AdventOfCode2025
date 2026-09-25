//
//  Day09.swift
//  AoC2025
//

import Foundation
import Algorithms

class Day09: AoCSolution {
	override init() {
		super.init()
		day = 9
		self.name = "Movie Theater"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let coords = input.textLines.map({ line in
			let strs = line.split(separator: ",")
			let ints = strs.compactMap({Int($0)})
			return AoCCoord2D(x: ints[0], y: ints[1])
		})
		
		let p1 = solvePartOne(coords)
		
		return AoCResult(part1: "The largest area is \(p1)", part2: "sync")
	}
	
	func solvePartOne(_ coords:[AoCCoord2D]) -> Int {
		var maxArea = 0
		
		for pair in Array(0..<coords.count).combinations(ofCount: 2) {
			let area = (abs(coords[pair[0]].x - coords[pair[1]].x) + 1) *
					   (abs(coords[pair[0]].y - coords[pair[1]].y) + 1)
			if area > maxArea { maxArea = area }
		}
		
		return maxArea
	}
}

struct AoCCompressionMap {
	private let compressionMapX: Dictionary<Int, Int>
	private let compressionMapY: Dictionary<Int, Int>
	private let expansionMapX: Dictionary<Int, Int>
	private let expansionMapY: Dictionary<Int, Int>
	
	init(coords:[AoCCoord2D]) {
		var cMapX = Dictionary<Int, Int>()
		var eMapX = Dictionary<Int, Int>()
		var cMapY = Dictionary<Int, Int>()
		var eMapY = Dictionary<Int, Int>()
		
		let xValueSet = Set(coords.map({$0.x}))
		let yValueSet = Set(coords.map({$0.y}))
		
		let xValues = Array(xValueSet).sorted()
		let yValues = Array(yValueSet).sorted()
		
		for i in 0..<xValues.count {
			eMapX[i] = xValues[i]
			cMapX[xValues[i]] = i
		}
		
		for i in 0..<yValues.count {
			eMapY[i] = yValues[i]
			cMapY[yValues[i]] = i
		}

		compressionMapX = cMapX
		compressionMapY = cMapY
		expansionMapX = eMapX
		expansionMapY = eMapY
	}
	
	func expand(_ coord:AoCCoord2D) -> AoCCoord2D {
		return AoCCoord2D(x: expansionMapX[coord.x]!,
						  y: expansionMapY[coord.y]!)
	}
	
	func compress(_ coord:AoCCoord2D) -> AoCCoord2D {
		return AoCCoord2D(x: compressionMapX[coord.x]!,
						  y: compressionMapY[coord.y]!)
	}
}
