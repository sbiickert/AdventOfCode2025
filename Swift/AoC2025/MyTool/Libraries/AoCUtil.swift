//
//	AoCUtil.swift
//	AoC 2025
//
//	Created by Simon Biickert on 2023-04-26.
//

import Foundation

class AoCUtil {
	public static let ALPHABET = "abcdefghijklmnopqrstuvwxyz"
	
	static func rangeToArray(r: Range<Int>) -> [Int] {
		var result = [Int]()
		for i in r {
			result.append(i)
		}
		return result
	}
	
	static func xorRanges(r1: Range<Int>, r2: Range<Int>) -> [Range<Int>] {
		guard r1.overlaps(r2) else { return [r1, r2] }
		let common = r1.clamped(to: r2)
		var results = [Range<Int>]()
		for r in [r1, r2] {
			if r.lowerBound < common.lowerBound {
				let exclusiveRange = r.lowerBound..<common.lowerBound
				results.append(exclusiveRange)
			}
			if common.upperBound < r.upperBound {
				let exclusiveRange = common.upperBound..<r.upperBound
				results.append(exclusiveRange)
            }
        }
        return results
    }
    
    static func intersectRanges(r1: Range<Int>, r2: Range<Int>) -> Range<Int>? {
        guard r1.overlaps(r2) else { return nil }
        return r1.clamped(to: r2)
    }
    
    static func cRangeToArray(r: ClosedRange<Int>) -> [Int] {
        var result = [Int]()
        for i in r {
            result.append(i)
        }
        return result
    }
    
    static func numberToIntArray(_ n: String) -> [Int] {
        return n.map {
            guard let digit = $0.wholeNumberValue, 0...9 ~= digit else {
                preconditionFailure("numberToIntArray: '\($0)' in \"\(n)\" is not a digit")
            }
            return digit
        }
    }
    
	// Have included Swift Algorithms as a dependency. Do not need this.
//    static func minMaxOf(array: [Int]) -> (Int, Int)? {
//        guard !array.isEmpty else { return nil }
//        
//        var min = Int.max
//        var max = Int.min
//        for value in array {
//            if value < min { min = value }
//            if value > max { max = value }
//        }
//        
//        return (min, max)
//    }
    
    static func trueMod(num: Int, mod: Int) -> Int {
        return (mod + (num % mod)) % mod;
    }
    
    /// The greatest common divisor of the two values.
    /// Defined on magnitudes, so the result is never negative, and gcd(0, 0) is 0.
    static func gcd(_ x:Int, _ y:Int) -> Int {
        // Works in magnitudes so that negative inputs (and Int.min) cannot
        // produce a negative divisor or overflow.
        var b = Swift.max(x.magnitude, y.magnitude)
        var r = Swift.min(x.magnitude, y.magnitude)
        while r != 0 {
            (b, r) = (r, b % r)
        }
        return Int(b)
    }
    
    /// The least common multiple of the two values, or 0 if either value is 0.
    static func lcm(_ x:Int, _ y:Int) -> Int {
        let divisor = gcd(x, y)
        guard divisor != 0 else { return 0 }
        return x / divisor * y
    }
    
    static func lcm(values:[Int]) -> Int {
        guard !values.isEmpty else { return 0 }
        var running = values.first!
        for n in 1..<values.count {
            running = lcm(running,values[n])
        }
        return running
    }
	
	static func pivotMatrix(_ matrix: [[Any]]) -> [[Any]] {
		guard !matrix.isEmpty else { return [] }
		let nrow = matrix.count
		let ncol = matrix[0].count
		
		var pivot: [[Any]] = []
		for _ in 0..<ncol {
			pivot.append([Any](repeating: 0, count: nrow))
		}
		
		for row in 0..<nrow {
			for col in 0..<ncol {
				pivot[col][row] = matrix[row][col]
			}
		}
		
		return pivot
	}
	
	static func joinDigits(_ digits:[Int]) -> Int {
		var value = 0
		
		for i in stride(from: digits.count-1, through: 0, by: -1) {
			let exponent = (digits.count-1) - i;
			value += digits[i] * AoCUtil.powerOf(base: 10, toExponent: exponent)
		}
		
		return value
	}
	
	static func powerOf(base:Int, toExponent exponent:Int) -> Int {
		var result = 1
		for i in 0..<exponent {
			result *= base
		}
		return result
	}
}


struct Fraction: Equatable {
	let numerator:Int
	let denominator:Int

	init(numerator: Int, denominator: Int) {
		self.numerator = numerator
		self.denominator = denominator
	}
	
	init(_ numerator: Int, _ denominator:Int) {
		self.numerator = numerator
		self.denominator = denominator
	}
	
	func reduce() -> Fraction {
		let gcd = AoCUtil.gcd(numerator, denominator)
		guard gcd != 0 else { return self }
		// AoCUtil.gcd is never negative, so normalise the sign onto the
		// numerator to keep the reduced form canonical.
		let sign = denominator < 0 ? -1 : 1
		return Fraction(numerator: sign * numerator/gcd, denominator: sign * denominator/gcd)
	}
}

