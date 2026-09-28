//
//  Day10.swift
//  AoC2025
//

import Foundation

class Day10: AoCSolution {
	override init() {
		super.init()
		day = 10
		self.name = "Factory"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let machines = input.textLines.map { DXMachine(defn: $0) }
		
		let p1 = solvePartOne(machines)
		let p2 = solvePartTwo(machines)
		
		return AoCResult(part1: "The fewest presses is \(p1)", part2: "The fewest presses is \(p2)")
	}
	
	func solvePartOne(_ machines:[DXMachine]) -> Int {
		var total = 0
		for machine in machines {
			let solutions = DXMachine.solveFor(parity: DXMachine.parity(of: machine.lightGoal),
											   buttons: machine.buttons)
			let pc = solutions.first?.pressCount ?? -1
			assert(pc > 0)
			total += pc
		}
		return total
	}
	
	func solvePartTwo(_ machines:[DXMachine]) -> Int {
		var total = 0
		for machine in machines {
			let count = DXMachine.bifurcateToVictory(total: 0,
													 buttons: machine.buttons,
													 joltageGoal: machine.joltGoal) / 2
			total += count
		}
		
		return total
	}
}

struct DXMachine {
	let lightGoal: [Bool]
	let buttons: [DXButton]
	let joltGoal: [Int]
	
	init(defn: String) {
		// e.g. [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
		let re = /\[([#\.]+)\] (.+) {([\d,]+)}/
		if let m = defn.firstMatch(of: re) {
			let lightDefn = m.1
			let buttonsDefn = m.2
			let joltDefn = m.3
			
			lightGoal = lightDefn.map { $0 == "#" }
			buttons = DXButton.parseButtons(defn: String(buttonsDefn))
			joltGoal = joltDefn.components(separatedBy: ",").compactMap { Int($0) }
		}
		else {
			lightGoal = []
			buttons = []
			joltGoal = []
		}
		assert(!lightGoal.isEmpty)
	}
	
	static var _cache = Dictionary<[DXButton], Dictionary<Int, [DXSolution]>>()
	
	static func solveFor(parity goal:Int, buttons:[DXButton]) -> [DXSolution] {
		if let cacheHit = _cache[buttons] { return cacheHit[goal] ?? [] }
		
		var buckets = Dictionary<Int, [DXSolution]>()
		let n = buttons.count
		for mask in 0..<(1 << n) {
			var state = 0
			var count = 0
			var history = [Int]()
			for i in 0..<n {
				let pressed = mask & (1 << i) != 0
				history.append(pressed ? 1 : 0)
				if pressed {
					count += 1
					for idx in buttons[i].indexes {
						state ^= AoCUtil.powerOf(base: 2, toExponent: idx)
					}
				}
			}
			buckets[state, default: []].append(DXSolution(presses: history))
		}
		
		for keyValue in buckets {
			let state = keyValue.key
			let bucket = keyValue.value
			let sorted = bucket.sorted { $0.pressCount < $1.pressCount }
			buckets[state] = sorted
		}
		
		_cache[buttons] = buckets
		
		return buckets[goal] ?? []
	}
	
	static func bifurcateToVictory(total: Int,
								   buttons: [DXButton],
								   joltageGoal: [Int]) -> Int {
		guard joltageGoal.allSatisfy({ $0 == 0 }) == false else { return total }
		
		let jParity = DXMachine.parity(of: DXMachine.joltsToLights(joltageGoal))
		let solutions = DXMachine.solveFor(parity: jParity, buttons: buttons)
		var fewestRecursivePresses = 1000000
		
		for solution in solutions {
			let newJoltages = DXMachine.subtractButtonPresses(presses: solution.presses,
															  of: buttons,
															  from: joltageGoal)
			
			if let _ = newJoltages.first(where: { $0 < 0 }) {
				continue
			}

			let dividedJoltages = newJoltages.map { $0 / 2 }
			
			let recursivePresses = DXMachine.bifurcateToVictory(total: solution.pressCount,
																buttons: buttons,
																joltageGoal: dividedJoltages)
			if recursivePresses < fewestRecursivePresses {
				fewestRecursivePresses = recursivePresses
			}
		}
		
		return (2 * fewestRecursivePresses) + total
	}
	
	static func subtractButtonPresses(presses: [Int], of buttons: [DXButton], from joltages: [Int]) -> [Int] {
		var result = joltages.map {$0}
		for i in 0..<presses.count {
			let button = buttons[i]
			let pressCount = presses[i]
			for _ in 0..<pressCount {
				for joltIndex in button.indexes {
					result[joltIndex] -= 1
				}
			}
		}
		return result
	}
	
	static func joltsToLights(_ jolts:[Int]) -> [Bool] {
		return jolts.map { $0 % 2 == 1 } // Odd values are true
	}
	
	static func parity(of lights:[Bool]) -> Int {
		var parity = 0
		for place in 0..<lights.count {
			if (lights[place] == true) {
				parity += AoCUtil.powerOf(base: 2, toExponent: place)
			}
		}
		return parity
	}
}

struct DXSolution {
	let presses: [Int]
	
	var pressCount: Int {
		return presses.reduce(0, +)
	}
}

struct DXButton: Equatable, Hashable {
	static func parseButtons(defn:String) -> [DXButton] {
		var b = [DXButton]()
		let re = /\(([\d,]+)\)/
		for m in defn.matches(of: re) {
			b.append(DXButton(defn: String(m.1)))
		}
		return b
	}
	
	init(defn: String) {
		indexes = defn.components(separatedBy: ",").compactMap { Int($0) }
	}
	
	let indexes: [Int]
}
