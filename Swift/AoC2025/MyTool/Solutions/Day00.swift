//
//  Day00.swift
//  AoC 2025
//

import Foundation

class Day00: AoCSolution {
    override init() {
        super.init()
        day = 0
        self.name = "Test Solution"
        self.emptyLinesIndicateMultipleInputs = true
    }
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		return AoCResult(part1: "hello", part2: "sync")
	}
}
