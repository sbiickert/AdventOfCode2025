//
//  AoCUtilTests.swift
//  AoCLibraryTests
//

import Testing
import Foundation

@Suite("AoCUtil: ranges")
struct AoCUtilRangeTests {

    @Test func rangeToArrayEnumeratesHalfOpenRange() {
        #expect(AoCUtil.rangeToArray(r: 3..<7) == [3, 4, 5, 6])
        #expect(AoCUtil.rangeToArray(r: -2..<2) == [-2, -1, 0, 1])
    }

    @Test func rangeToArrayOfEmptyRangeIsEmpty() {
        #expect(AoCUtil.rangeToArray(r: 5..<5).isEmpty)
    }

    @Test func closedRangeToArrayIncludesUpperBound() {
        #expect(AoCUtil.cRangeToArray(r: 3...6) == [3, 4, 5, 6])
        #expect(AoCUtil.cRangeToArray(r: 5...5) == [5])
    }

    @Test func intersectOverlappingRanges() {
        #expect(AoCUtil.intersectRanges(r1: 0..<10, r2: 5..<15) == 5..<10)
        #expect(AoCUtil.intersectRanges(r1: 5..<15, r2: 0..<10) == 5..<10)
    }

    @Test func intersectNestedRangesReturnsInnerRange() {
        #expect(AoCUtil.intersectRanges(r1: 0..<100, r2: 40..<50) == 40..<50)
        #expect(AoCUtil.intersectRanges(r1: 40..<50, r2: 0..<100) == 40..<50)
    }

    @Test func intersectIdenticalRanges() {
        #expect(AoCUtil.intersectRanges(r1: 2..<8, r2: 2..<8) == 2..<8)
    }

    @Test func intersectDisjointRangesIsNil() {
        #expect(AoCUtil.intersectRanges(r1: 0..<5, r2: 10..<15) == nil)
    }

    /// Half-open ranges that merely touch (`0..<5`, `5..<10`) share no element,
    /// so they do not intersect.
    @Test func intersectAbuttingRangesIsNil() {
        #expect(AoCUtil.intersectRanges(r1: 0..<5, r2: 5..<10) == nil)
    }

    @Test func xorOfPartiallyOverlappingRangesKeepsTheExclusiveTails() {
        let result = AoCUtil.xorRanges(r1: 0..<10, r2: 5..<15)
        #expect(Set(result) == Set([0..<5, 10..<15]))
    }

    @Test func xorOfNestedRangesKeepsBothSidesOfTheInnerRange() {
        let result = AoCUtil.xorRanges(r1: 0..<10, r2: 4..<6)
        #expect(Set(result) == Set([0..<4, 6..<10]))
    }

    @Test func xorOfIdenticalRangesIsEmpty() {
        #expect(AoCUtil.xorRanges(r1: 2..<8, r2: 2..<8).isEmpty)
    }

    /// Documented behaviour: disjoint inputs are passed straight back out, so the
    /// result is *not* always a set of exclusive sub-ranges of a common span.
    @Test func xorOfDisjointRangesReturnsBothInputs() {
        let result = AoCUtil.xorRanges(r1: 0..<5, r2: 10..<15)
        #expect(result == [0..<5, 10..<15])
    }

    @Test func xorResultsAreDisjointFromTheIntersection() {
        let r1 = 3..<20
        let r2 = 12..<31
        let common = AoCUtil.intersectRanges(r1: r1, r2: r2)!
        for exclusive in AoCUtil.xorRanges(r1: r1, r2: r2) {
            #expect(!exclusive.overlaps(common))
        }
    }
}

@Suite("AoCUtil: numbers")
struct AoCUtilNumberTests {

    @Test func alphabetIsTheLowercaseLatinAlphabet() {
        #expect(AoCUtil.ALPHABET.count == 26)
        #expect(AoCUtil.ALPHABET.first == "a")
        #expect(AoCUtil.ALPHABET.last == "z")
    }

    @Test func numberToIntArraySplitsDigits() {
        #expect(AoCUtil.numberToIntArray("1234") == [1, 2, 3, 4])
        #expect(AoCUtil.numberToIntArray("0") == [0])
        #expect(AoCUtil.numberToIntArray("1002") == [1, 0, 0, 2])
    }

    @Test func numberToIntArrayOfEmptyStringIsEmpty() {
        // Note: a non-digit character is a programmer error and trips a
        // precondition naming the offending character, so it cannot be tested
        // here without killing the test process.
        #expect(AoCUtil.numberToIntArray("").isEmpty)
    }

    @Test func numberToIntArrayHandlesLongRuns() {
        let digits = String(repeating: "9876543210", count: 5)
        let result = AoCUtil.numberToIntArray(digits)
        #expect(result.count == 50)
        #expect(result.allSatisfy { 0...9 ~= $0 })
        #expect(Array(result.prefix(10)) == [9, 8, 7, 6, 5, 4, 3, 2, 1, 0])
    }

    @Test(arguments: [(7, 5, 2), (5, 5, 0), (0, 5, 0), (-1, 5, 4), (-7, 5, 3), (-5, 5, 0), (13, 1, 0)])
    func trueModIsAlwaysNonNegative(_ c: (num: Int, mod: Int, expected: Int)) {
        #expect(AoCUtil.trueMod(num: c.num, mod: c.mod) == c.expected)
    }

    @Test func trueModWrapsCoordinatesAcrossManyPeriods() {
        for i in -20...20 {
            let m = AoCUtil.trueMod(num: i, mod: 7)
            #expect(m >= 0 && m < 7)
            #expect((i - m) % 7 == 0)
        }
    }

    @Test(arguments: [(12, 18, 6), (18, 12, 6), (7, 13, 1), (100, 10, 10), (10, 100, 10), (9, 9, 9), (1, 1, 1)])
    func gcdOfPositiveValues(_ c: (x: Int, y: Int, expected: Int)) {
        #expect(AoCUtil.gcd(c.x, c.y) == c.expected)
    }

    @Test func gcdWithZeroReturnsTheOtherValue() {
        #expect(AoCUtil.gcd(0, 5) == 5)
        #expect(AoCUtil.gcd(5, 0) == 5)
        // Both zero has no defined divisor; the implementation reports 0.
        #expect(AoCUtil.gcd(0, 0) == 0)
    }

    /// The GCD is defined on magnitudes, so it is never negative.
    @Test func gcdIgnoresSigns() {
        #expect(AoCUtil.gcd(-12, 18) == 6)
        #expect(AoCUtil.gcd(12, -18) == 6)
        #expect(AoCUtil.gcd(-12, -18) == 6)
        #expect(AoCUtil.gcd(-4, -2) == 2)
        #expect(AoCUtil.gcd(-7, 0) == 7)
    }

    @Test func gcdIsNeverNegativeAndAlwaysDividesBothInputs() {
        for x in -12...12 {
            for y in -12...12 {
                let g = AoCUtil.gcd(x, y)
                #expect(g >= 0)
                if g != 0 {
                    #expect(x % g == 0)
                    #expect(y % g == 0)
                }
                else {
                    #expect(x == 0 && y == 0)
                }
            }
        }
    }

    /// `abs(Int.min)` is not representable, so the implementation works in
    /// magnitudes internally. Only the result has to fit in an `Int` — which
    /// rules out gcd(Int.min, Int.min), whose true value is 2^63.
    @Test func gcdHandlesExtremeValuesWithoutOverflowing() {
        #expect(AoCUtil.gcd(Int.max, 1) == 1)
        #expect(AoCUtil.gcd(Int.min, 2) == 2)
        #expect(AoCUtil.gcd(Int.min, 6) == 2)
        #expect(AoCUtil.gcd(Int.min + 1, Int.max) == Int.max)
    }

    @Test(arguments: [(4, 6, 12), (6, 4, 12), (21, 6, 42), (7, 13, 91), (5, 5, 5), (1, 9, 9)])
    func lcmOfTwoValues(_ c: (x: Int, y: Int, expected: Int)) {
        #expect(AoCUtil.lcm(c.x, c.y) == c.expected)
    }

    @Test func lcmOfAnArray() {
        #expect(AoCUtil.lcm(values: [4, 6, 8]) == 24)
        #expect(AoCUtil.lcm(values: [2, 3, 5, 7]) == 210)
        #expect(AoCUtil.lcm(values: [7]) == 7)
    }

    @Test func lcmOfAnEmptyArrayIsZero() {
        #expect(AoCUtil.lcm(values: []) == 0)
    }

    /// Zero has no non-zero multiple, so the LCM collapses to 0 rather than
    /// dividing by a zero divisor.
    @Test func lcmInvolvingZeroIsZero() {
        #expect(AoCUtil.lcm(0, 0) == 0)
        #expect(AoCUtil.lcm(0, 7) == 0)
        #expect(AoCUtil.lcm(7, 0) == 0)
        #expect(AoCUtil.lcm(values: [4, 0, 6]) == 0)
        #expect(AoCUtil.lcm(values: [0]) == 0)
    }

    @Test func lcmIsDivisibleByEveryInput() {
        let values = [3, 4, 10, 15]
        let result = AoCUtil.lcm(values: values)
        for v in values {
            #expect(result % v == 0)
        }
    }
}

@Suite("AoCUtil: matrices")
struct AoCUtilMatrixTests {

    @Test func pivotTransposesARectangularMatrix() {
        let matrix: [[Any]] = [[1, 2, 3],
                               [4, 5, 6]]
        let pivot = AoCUtil.pivotMatrix(matrix)
        #expect(pivot.count == 3)
        #expect(pivot.allSatisfy { $0.count == 2 })
        #expect(pivot.map { $0.map { $0 as! Int } } == [[1, 4], [2, 5], [3, 6]])
    }

    @Test func pivotOfASingleRowBecomesASingleColumn() {
        let pivot = AoCUtil.pivotMatrix([["a", "b", "c"]])
        #expect(pivot.map { $0.map { $0 as! String } } == [["a"], ["b"], ["c"]])
    }

    @Test func pivotTwiceIsTheOriginalMatrix() {
        let matrix: [[Any]] = [[1, 2, 3], [4, 5, 6]]
        let roundTrip = AoCUtil.pivotMatrix(AoCUtil.pivotMatrix(matrix))
        #expect(roundTrip.map { $0.map { $0 as! Int } } == [[1, 2, 3], [4, 5, 6]])
    }

    @Test func pivotOfAnEmptyMatrixIsEmpty() {
        #expect(AoCUtil.pivotMatrix([]).isEmpty)
    }
}

@Suite("Fraction")
struct FractionTests {

    @Test func bothInitialisersAgree() {
        #expect(Fraction(numerator: 3, denominator: 4) == Fraction(3, 4))
    }

    @Test func equalityComparesUnreducedComponents() {
        #expect(Fraction(1, 2) != Fraction(2, 4))
        #expect(Fraction(1, 2) == Fraction(1, 2))
    }

    @Test func reduceDividesByTheGreatestCommonDivisor() {
        #expect(Fraction(6, 8).reduce() == Fraction(3, 4))
        #expect(Fraction(100, 10).reduce() == Fraction(10, 1))
        #expect(Fraction(5, 5).reduce() == Fraction(1, 1))
    }

    @Test func reduceOfAnAlreadyReducedFractionIsUnchanged() {
        #expect(Fraction(3, 7).reduce() == Fraction(3, 7))
    }

    @Test func reduceOfZeroNumerator() {
        #expect(Fraction(0, 5).reduce() == Fraction(0, 1))
    }

    /// The reduced form is canonical: the sign lives on the numerator.
    @Test func reduceNormalisesTheSign() {
        #expect(Fraction(-6, 8).reduce() == Fraction(-3, 4))
        #expect(Fraction(6, -8).reduce() == Fraction(-3, 4))
        #expect(Fraction(-6, -8).reduce() == Fraction(3, 4))
        #expect(Fraction(-4, -2).reduce() == Fraction(2, 1))
    }

    @Test func reduceOfAZeroDenominatorIsLeftAlone() {
        // Nonsensical input, but it must not divide by zero.
        #expect(Fraction(0, 0).reduce() == Fraction(0, 0))
    }

    @Test func reduceIsIdempotent() {
        for numerator in -8...8 {
            for denominator in -8...8 {
                let once = Fraction(numerator, denominator).reduce()
                #expect(once.reduce() == once)
            }
        }
    }
}
