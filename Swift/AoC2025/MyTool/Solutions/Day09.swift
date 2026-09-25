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
		let p2 = solvePartTwo(coords)
		
		return AoCResult(part1: "The largest area is \(p1)", part2: "The largest solid area is \(p2)")
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
	
	func solvePartTwo(_ coords:[AoCCoord2D]) -> Int {
		let cMap = AoCCompressionMap(coords: coords)
		
		let compressed = coords.map { cMap.compress($0) }
		let grid = paintGrid(compressedCoordinates: compressed)
		
		var maxArea = 0
		
		for pair in Array(0..<coords.count).combinations(ofCount: 2) {
			// Is the expanded area > than maxArea?
			let area = (abs(coords[pair[0]].x - coords[pair[1]].x) + 1) *
					   (abs(coords[pair[0]].y - coords[pair[1]].y) + 1)
			
			// If not, move on
			if area <= maxArea { continue }
			
			// Is every coord along the edge the same colour?
			var ok = true
			let ext = AoCExtent2D(min: compressed[pair[0]], max: compressed[pair[1]])
			for x in ext.min.x...ext.max.x {
				for y in ext.min.y...ext.max.y {
					if x == ext.min.x || x == ext.max.x || y == ext.min.y || y == ext.max.y {
						if grid.stringValue(at: AoCCoord2D(x: x, y: y)) != "#" {
							ok = false
							break
						}
					}
				}
				if ok == false {break}
			}
			
			if ok {
				maxArea = area
				//print("\(maxArea)")
			}
		}
		
		return maxArea
	}
	
	func paintGrid(compressedCoordinates coords:[AoCCoord2D]) -> AoCGrid2D {
		let grid = AoCGrid2D(defaultValue: ".", rule: .rook)
		
		// Paint Edges
		for i in 0..<coords.count {
			let c1 = coords[i]
			var c2 = coords[0]
			if i < coords.count - 1 { c2 = coords[i+1] }
			
			let seg = AoCSegment2D(from: c1, to: c2)
			var ptr = seg.from
			while ptr != seg.to {
				grid.setValue("#", at: ptr)
				ptr = ptr + seg.direction.offset
			}
		}
		
		// Fill
		let ext = grid.extent!
		for x in ext.min.x...ext.max.x {
			let c = AoCCoord2D(x: x, y: ext.min.y)
			let south = AoCCoord2D(x: x, y: c.y+1)
			if grid.stringValue(at: c) == "#" && grid.stringValue(at: south) == "." {
				var filled = [AoCCoord2D]()
				let _ = grid.fill(with: "#", at: south, filled: &filled)
				break;
			}
		}
		
		return grid
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
