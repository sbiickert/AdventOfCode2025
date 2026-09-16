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
		let p1 = solvePartOne(turns: turns)
		let p2 = solvePartTwo(turns: turns)
		
		return AoCResult(part1: "The password is \(p1)", part2: "The password is \(p2)")
	}
	
	func solvePartOne(turns:[DialTurn]) -> Int {
		var value = 50
		var zeroCount = 0;
		
		for turn in turns {
			value += turn.size * turn.offset
			value = AoCUtil.trueMod(num: value, mod: 100)
			if value == 0 {
				zeroCount += 1
			}
		}
		
		return zeroCount
	}
	
	func solvePartTwo(turns:[DialTurn]) -> Int {
		var value = 50
		var zeroCount = 0;
		
		for turn in turns {
			for _ in 0..<turn.size {
				value += turn.offset
				value = AoCUtil.trueMod(num: value, mod: 100)
				if value == 0 {
					zeroCount += 1
				}
			}
		}
		
		return zeroCount
	}
	
	func parseTurns(input: [String]) -> [DialTurn] {
		let turns = input.map { line in
			let d = String(line.first ?? "x")
			assert(d != "x")
			let s = Int(line.dropFirst(1)) ?? -1
			assert(s >= 0)
			return DialTurn(dir: d, size: s)
		}
		return turns
	}
}

struct DialTurn {
	let dir: String
	let size: Int
	
	var offset:Int {
		return (dir == "R") ? 1 : -1
	}
}

