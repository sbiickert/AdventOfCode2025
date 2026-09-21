//
//  day06.swift
//  AoC2025
//

import Foundation

class Day06: AoCSolution {
	override init() {
		super.init()
		day = 6
		self.name = "Trash Compactor"
		self.emptyLinesIndicateMultipleInputs = true
	}
	
	override func solve(_ input: AoCInput) -> AoCResult {
		super.solve(input)
		
		let equations = parseEquations(input: input.textLines)
		
		let p1 = equations.map( { $0.hResult }).reduce(0, +)
		let p2 = equations.map( { $0.vResult }).reduce(0, +)

		return AoCResult(part1: "The sum is \(p1)", part2: "The sum is \(p2)")
	}
	
	func parseEquations(input:[String]) -> [CephalopodEquation] {
		var result = [CephalopodEquation]()
		
		let operatorLine = input.last!
		for i in 0..<operatorLine.count {
			if operatorLine[i] != " " {
				result.append(CephalopodEquation(input, offset: i))
			}
		}
		
		return result
	}
}

struct CephalopodEquation {
	let digits: [[Int?]]
	let op: String
	
	init(_ src:[String], offset:Int) {
		op = String(src.last![offset])
		
		var d = [[Int?]]()
		for _ in 0..<src.count-1 {
			d.append([Int?]())
		}
		
		var i = offset
		while i < src[0].count {
			var s = [String]()
			for j in 0..<src.count-1 {
				s.append( String(src[j][i]) )
			}
			if s.allSatisfy({$0 == " "}) {break}
			
			for j in 0..<src.count-1 {
				d[j].append(Int(s[j]) ?? nil)
			}
			i += 1
		}
		
		digits = d
	}
	
	var hNumbers: [Int] {
		return digits.map { row in
			let s = row.compactMap( { digit in
				if let digit {
					return String(digit)
				}
				return nil })
				.joined()
			return Int(s)!
		}
	}
	
	var vNumbers: [Int] {
		var cols = [String]()
		for i in 0..<digits[0].count {
			var col = ""
			for row in 0..<digits.count {
				if let digit = digits[row][i] {
					col.append(String(digit))
				}
			}
			cols.append(col)
		}
		return cols.map { Int($0)! }
	}
	
	var hResult: Int {
		if op == "+" {
			return hNumbers.reduce(0, +)
		}
		return hNumbers.reduce(1, *)
	}
	
	var vResult: Int {
		if op == "+" {
			return vNumbers.reduce(0, +)
		}
		return vNumbers.reduce(1, *)
	}
}
