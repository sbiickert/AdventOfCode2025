//
//  AoCDirectionTests.swift
//  AoCLibraryTests
//
//  AoCDir, AoCDir3D, AoCTurn and AoCTurnSize.
//

import Testing
import Foundation

@Suite("AoCDir")
struct AoCDirTests {

    @Test func allEightCompassPointsExistInClockwiseOrder() {
        #expect(AoCDir.allCases == [.north, .ne, .east, .se, .south, .sw, .west, .nw])
    }

    /// The grid uses screen coordinates: +x is east, +y is *south*.
    @Test func offsetsUseScreenCoordinates() {
        #expect(AoCDir.north.offset == AoCCoord2D(x: 0, y: -1))
        #expect(AoCDir.south.offset == AoCCoord2D(x: 0, y: 1))
        #expect(AoCDir.east.offset == AoCCoord2D(x: 1, y: 0))
        #expect(AoCDir.west.offset == AoCCoord2D(x: -1, y: 0))
        #expect(AoCDir.ne.offset == AoCCoord2D(x: 1, y: -1))
        #expect(AoCDir.se.offset == AoCCoord2D(x: 1, y: 1))
        #expect(AoCDir.sw.offset == AoCCoord2D(x: -1, y: 1))
        #expect(AoCDir.nw.offset == AoCCoord2D(x: -1, y: -1))
    }

    @Test func opposingOffsetsCancelOut() {
        let pairs: [(AoCDir, AoCDir)] = [(.north, .south), (.east, .west), (.ne, .sw), (.nw, .se)]
        for (a, b) in pairs {
            #expect(a.offset + b.offset == AoCCoord2D.origin)
        }
    }

    @Test func rawValuesAreTheCompassAbbreviations() {
        #expect(AoCDir.north.rawValue == "N")
        #expect(AoCDir.se.rawValue == "SE")
        #expect(AoCDir(rawValue: "W") == .west)
        #expect(AoCDir(rawValue: "NE") == .ne)
        #expect(AoCDir(rawValue: "Q") == nil)
    }

    @Test(arguments: [("^", AoCDir.north), ("up", .north), ("u", .north), ("U", .north),
                      ("<", .west), ("left", .west), ("l", .west), ("L", .west),
                      (">", .east), ("right", .east), ("r", .east),
                      ("v", .south), ("V", .south), ("down", .south), ("d", .south),
                      ("nw", .nw), ("NW", .nw), ("sw", .sw), ("ne", .ne), ("SE", .se)])
    func fromAliasAcceptsPuzzleNotation(_ c: (alias: String, expected: AoCDir)) {
        #expect(AoCDir.fromAlias(c.alias) == c.expected)
    }

    @Test func fromAliasRejectsUnknownText() {
        #expect(AoCDir.fromAlias("") == nil)
        #expect(AoCDir.fromAlias("north") == nil)
        #expect(AoCDir.fromAlias("x") == nil)
    }

    @Test func turnDirectionToSelfIsNone() {
        for dir in AoCDir.allCases {
            #expect(dir.turnDirection(to: dir) == .none)
        }
    }

    @Test func turnDirectionForTheThreeDirectionsCounterClockwise() {
        #expect(AoCDir.north.turnDirection(to: .west) == .left)
        #expect(AoCDir.north.turnDirection(to: .nw) == .left)
        #expect(AoCDir.north.turnDirection(to: .sw) == .left)
        #expect(AoCDir.east.turnDirection(to: .north) == .left)
        #expect(AoCDir.south.turnDirection(to: .east) == .left)
        #expect(AoCDir.west.turnDirection(to: .south) == .left)
    }

    @Test func turnDirectionForTheThreeDirectionsClockwise() {
        #expect(AoCDir.north.turnDirection(to: .east) == .right)
        #expect(AoCDir.north.turnDirection(to: .ne) == .right)
        #expect(AoCDir.east.turnDirection(to: .south) == .right)
        #expect(AoCDir.south.turnDirection(to: .west) == .right)
        #expect(AoCDir.west.turnDirection(to: .north) == .right)
    }

    /// A 45° turn is always reported as the matching turn direction.
    @Test func turnDirectionAgreesWithASingleStepTurn() {
        for dir in AoCDir.allCases {
            let right = AoCTurn.right.apply(to: dir, size: .fortyFive)
            let left = AoCTurn.left.apply(to: dir, size: .fortyFive)
            #expect(dir.turnDirection(to: right) == .right)
            #expect(dir.turnDirection(to: left) == .left)
        }
    }

    /// Documented behaviour: a 180° reversal is not ambiguous to the
    /// implementation — it always reports `.right`.
    @Test func turnDirectionForAReversalIsRight() {
        for dir in AoCDir.allCases {
            let reversed = AoCTurn.right.apply(to: dir, size: .oneEighty)
            #expect(dir.turnDirection(to: reversed) == .right)
        }
    }

    @Test func turnDirectionIsNeverNoneForDifferentDirections() {
        for a in AoCDir.allCases {
            for b in AoCDir.allCases where a != b {
                #expect(a.turnDirection(to: b) != AoCTurn.none)
            }
        }
    }
}

@Suite("AoCDir3D")
struct AoCDir3DTests {

    @Test func allSixFacesExist() {
        #expect(AoCDir3D.allCases.count == 6)
        #expect(Set(AoCDir3D.allCases.map { $0.rawValue }) == Set(["U", "D", "L", "R", "F", "B"]))
    }

    @Test func offsetsAreUnitStepsAlongOneAxis() {
        #expect(AoCDir3D.up.offset == AoCCoord3D(x: 0, y: 0, z: 1))
        #expect(AoCDir3D.down.offset == AoCCoord3D(x: 0, y: 0, z: -1))
        #expect(AoCDir3D.left.offset == AoCCoord3D(x: -1, y: 0, z: 0))
        #expect(AoCDir3D.right.offset == AoCCoord3D(x: 1, y: 0, z: 0))
        #expect(AoCDir3D.forward.offset == AoCCoord3D(x: 0, y: -1, z: 0))
        #expect(AoCDir3D.back.offset == AoCCoord3D(x: 0, y: 1, z: 0))
    }

    @Test func everyOffsetIsOneStepFromTheOrigin() {
        for dir in AoCDir3D.allCases {
            #expect(AoCCoord3D.origin.manhattanDistance(to: dir.offset) == 1)
        }
    }

    @Test func opposingOffsetsCancelOut() {
        let pairs: [(AoCDir3D, AoCDir3D)] = [(.up, .down), (.left, .right), (.forward, .back)]
        for (a, b) in pairs {
            #expect(a.offset + b.offset == AoCCoord3D.origin)
        }
    }

    @Test func rawValueRoundTrips() {
        for dir in AoCDir3D.allCases {
            #expect(AoCDir3D(rawValue: dir.rawValue) == dir)
        }
    }
}

@Suite("AoCTurn")
struct AoCTurnTests {

    @Test(arguments: [("ccw", AoCTurn.left), ("left", .left), ("l", .left), ("L", .left),
                      ("cw", .right), ("right", .right), ("r", .right), ("CW", .right)])
    func fromAliasAcceptsPuzzleNotation(_ c: (alias: String, expected: AoCTurn)) {
        #expect(AoCTurn.fromAlias(c.alias) == c.expected)
    }

    @Test func fromAliasFallsBackToNone() {
        #expect(AoCTurn.fromAlias("") == AoCTurn.none)
        #expect(AoCTurn.fromAlias("straight") == AoCTurn.none)
    }

    @Test func turnSizesAreCountedInFortyFiveDegreeSteps() {
        #expect(AoCTurnSize.zero.rawValue == 0)
        #expect(AoCTurnSize.fortyFive.rawValue == 1)
        #expect(AoCTurnSize.ninety.rawValue == 2)
        #expect(AoCTurnSize.oneEighty.rawValue == 4)
    }

    @Test func ninetyDegreesIsTheDefaultTurnSize() {
        #expect(AoCTurn.right.apply(to: .north) == .east)
        #expect(AoCTurn.left.apply(to: .north) == .west)
    }

    @Test func rightTurnsOfNinetyDegrees() {
        #expect(AoCTurn.right.apply(to: .north, size: .ninety) == .east)
        #expect(AoCTurn.right.apply(to: .east, size: .ninety) == .south)
        #expect(AoCTurn.right.apply(to: .south, size: .ninety) == .west)
        #expect(AoCTurn.right.apply(to: .west, size: .ninety) == .north)
    }

    @Test func leftTurnsOfNinetyDegrees() {
        #expect(AoCTurn.left.apply(to: .north, size: .ninety) == .west)
        #expect(AoCTurn.left.apply(to: .west, size: .ninety) == .south)
        #expect(AoCTurn.left.apply(to: .south, size: .ninety) == .east)
        #expect(AoCTurn.left.apply(to: .east, size: .ninety) == .north)
    }

    @Test func fortyFiveDegreeTurnsStepThroughTheDiagonals() {
        #expect(AoCTurn.right.apply(to: .north, size: .fortyFive) == .ne)
        #expect(AoCTurn.right.apply(to: .nw, size: .fortyFive) == .north)
        #expect(AoCTurn.left.apply(to: .north, size: .fortyFive) == .nw)
        #expect(AoCTurn.left.apply(to: .ne, size: .fortyFive) == .north)
    }

    @Test func oneEightyReversesEveryDirection() {
        let expected: [AoCDir: AoCDir] = [.north: .south, .south: .north,
                                          .east: .west, .west: .east,
                                          .ne: .sw, .sw: .ne,
                                          .nw: .se, .se: .nw]
        for (from, to) in expected {
            #expect(AoCTurn.right.apply(to: from, size: .oneEighty) == to)
            #expect(AoCTurn.left.apply(to: from, size: .oneEighty) == to)
        }
    }

    @Test func aZeroSizeTurnOrANoneTurnKeepsTheDirection() {
        for dir in AoCDir.allCases {
            #expect(AoCTurn.right.apply(to: dir, size: .zero) == dir)
            #expect(AoCTurn.left.apply(to: dir, size: .zero) == dir)
            #expect(AoCTurn.none.apply(to: dir) == dir)
            #expect(AoCTurn.none.apply(to: dir, size: .oneEighty) == dir)
        }
    }

    @Test func turningLeftUndoesTurningRight() {
        for dir in AoCDir.allCases {
            for size in [AoCTurnSize.fortyFive, .ninety, .oneEighty] {
                let there = AoCTurn.right.apply(to: dir, size: size)
                #expect(AoCTurn.left.apply(to: there, size: size) == dir)
            }
        }
    }

    @Test func eightFortyFiveDegreeTurnsReturnToTheStart() {
        for dir in AoCDir.allCases {
            var current = dir
            for _ in 0..<8 {
                current = AoCTurn.right.apply(to: current, size: .fortyFive)
            }
            #expect(current == dir)
        }
    }

    @Test func fourNinetyDegreeTurnsReturnToTheStart() {
        for dir in AoCDir.allCases {
            var current = dir
            for _ in 0..<4 {
                current = AoCTurn.left.apply(to: current, size: .ninety)
            }
            #expect(current == dir)
        }
    }
}
