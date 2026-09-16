//
//  Day01.swift
//
//  Created by Simon Biickert on 2026-09-16.
//

import Foundation

class Day01: AoCSolution {
	override init() {
		super.init()
		day = 1
		self.name = "Secret Entrance"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let turns = parseTurns(input: input.textLines)
		
		var p1 = 0
		var p2 = 0
		var dialPosition = 50
		
		for turn in turns {
			for _ in 1...turn.size {
				dialPosition += turn.offset
				dialPosition = AoCUtil.trueMod(num: dialPosition, mod: 100)
				if dialPosition == 0 {
					p2 += 1 // If the dial passes zero
				}
			}
			if dialPosition == 0 {
				p1 += 1 // If the dial ends at zero
			}
		}

		return AoCResult(part1: "The password is \(p1)", part2: "The password is \(p2)")
	}
	
	func parseTurns(input: [String]) -> [DialTurn] {
		let turns = input.map { line in
			let d = String(line.first ?? "x")
			assert(d != "x")
			let s = Int(line.dropFirst(1)) ?? -1
			assert(s >= 0)
			let o = (d == "R") ? 1 : -1

			return DialTurn(dir: d, size: s, offset: o)
		}
		return turns
	}
}

struct DialTurn {
	let dir: String
	let size: Int
	let offset: Int
}

