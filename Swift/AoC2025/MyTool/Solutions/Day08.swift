//
//  Day08.swift
//  AoC2025
//

import Foundation

class Day08: AoCSolution {
	override init() {
		super.init()
		day = 8
		self.name = "Playground"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let jBoxes = parseJunctionBoxes(input: input.textLines)
		
		let (p1, p2) = solveParts(junctionBoxes: jBoxes,
								  sumAfter: jBoxes.count == 20 ? 10 : 1000)
		
		return AoCResult(part1: "The sum of 3 largest is \(p1)", part2: "The x product of the last boxes to merge groups was \(p2)")
	}
	
	func solveParts(junctionBoxes jBoxes:[AoCCoord3D], sumAfter:Int) -> (Int, Int) {
		var productOfThreeLargestGroups = -1
		var productOfXCoords = 0

		var distances = buildDistanceLookup(jBoxes)
		var groups = jBoxes.map { Set([$0]) }
		var i = 0
		
		while groups.count > 1 {
			i += 1
			let d = distances.popLast()!
			var index1 = -1
			var index2 = -1
			for j in 0..<groups.count {
				if groups[j].contains(d.jBox1) { index1 = j }
				if groups[j].contains(d.jBox2) { index2 = j }
				if index1 >= 0 && index2 >= 0 { break }
			}
			if index1 != index2 {
				let combined = groups[index1].union(groups[index2])
				for index in [index1,index2].sorted().reversed() {
					groups.remove(at: index)
				}
				groups.append(combined)
				productOfXCoords = d.jBox1.x * d.jBox2.x
			}
			
			if i == sumAfter {
				// Sum of sizes of 3 largest groups
				groups.sort { $0.count > $1.count }
				productOfThreeLargestGroups = groups[0..<3].map({$0.count}).reduce(1, *)
			}
		}
		
		return (productOfThreeLargestGroups, productOfXCoords)
	}
	
	func parseJunctionBoxes(input:[String]) -> [AoCCoord3D] {
		return input.map { line in
			let strs = line.split(separator: ",")
			let nums = strs.compactMap({Int($0)})
			return AoCCoord3D(x: nums[0], y: nums[1], z: nums[2])
		}
	}
	
	func buildDistanceLookup(_ jBoxes:[AoCCoord3D]) -> [JBoxConnection] {
		var result = [JBoxConnection]()
		
		for i in 0..<jBoxes.count-1 {
			for j in i+1..<jBoxes.count {
				let d = jBoxes[i].distance(to: jBoxes[j])
				result.append(JBoxConnection(jBox1: jBoxes[i], jBox2: jBoxes[j], distance: d))
			}
		}
		result.sort { $0.distance > $1.distance }
		
		return result
	}
}

struct JBoxConnection {
	let jBox1: AoCCoord3D
	let jBox2: AoCCoord3D
	let distance: Double
}
