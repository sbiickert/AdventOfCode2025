//
//  AoCCoordTests.swift
//  AoCLibraryTests
//
//  AoCCoord2D, AoCCoord3D and AoCPos2D.
//

import Testing
import Foundation

@Suite("AoCCoord2D")
struct AoCCoord2DTests {

    @Test func originIsZeroZero() {
        #expect(AoCCoord2D.origin == AoCCoord2D(x: 0, y: 0))
    }

    @Test func colAndRowAliasXAndY() {
        let c = AoCCoord2D(x: 3, y: 7)
        #expect(c.col == 3)
        #expect(c.row == 7)
    }

    @Test func additionAndSubtraction() {
        let a = AoCCoord2D(x: 3, y: 4)
        let b = AoCCoord2D(x: -1, y: 10)
        #expect(a + b == AoCCoord2D(x: 2, y: 14))
        #expect(a - b == AoCCoord2D(x: 4, y: -6))
        #expect(a + AoCCoord2D.origin == a)
        #expect(a - a == AoCCoord2D.origin)
    }

    @Test func equalAndUnequalCoordsHashConsistently() {
        let set: Set<AoCCoord2D> = [AoCCoord2D(x: 1, y: 2), AoCCoord2D(x: 1, y: 2), AoCCoord2D(x: 2, y: 1)]
        #expect(set.count == 2)
    }

    @Test func readingOrderSortsTopToBottomThenLeftToRight() {
        let coords = [AoCCoord2D(x: 2, y: 1), AoCCoord2D(x: 0, y: 1),
                      AoCCoord2D(x: 5, y: 0), AoCCoord2D(x: 1, y: 0)]
        let sorted = coords.sorted(by: AoCCoord2D.readingOrderSort)
        #expect(sorted == [AoCCoord2D(x: 1, y: 0), AoCCoord2D(x: 5, y: 0),
                           AoCCoord2D(x: 0, y: 1), AoCCoord2D(x: 2, y: 1)])
    }

    @Test func readingOrderIsFalseForEqualCoords() {
        let c = AoCCoord2D(x: 1, y: 1)
        #expect(AoCCoord2D.readingOrderSort(c0: c, c1: c) == false)
    }

    @Test func rookOffsetsAreTheFourEdgeNeighbours() {
        #expect(AoCCoord2D.getAdjacentOffsets(rule: .rook)
                == [AoCDir.north.offset, AoCDir.east.offset, AoCDir.south.offset, AoCDir.west.offset])
    }

    @Test func bishopOffsetsAreTheFourDiagonals() {
        #expect(Set(AoCCoord2D.getAdjacentOffsets(rule: .bishop))
                == Set([AoCDir.nw.offset, AoCDir.ne.offset, AoCDir.sw.offset, AoCDir.se.offset]))
    }

    @Test func queenOffsetsAreAllEightNeighbours() {
        let offsets = AoCCoord2D.getAdjacentOffsets(rule: .queen)
        #expect(offsets.count == 8)
        #expect(Set(offsets) == Set(AoCDir.allCases.map { $0.offset }))
    }

    @Test func rookIsTheDefaultRule() {
        #expect(AoCCoord2D.getAdjacentOffsets() == AoCCoord2D.getAdjacentOffsets(rule: .rook))
    }

    @Test func offsetsAreCachedAndStable() {
        #expect(AoCCoord2D.getAdjacentOffsets(rule: .queen) == AoCCoord2D.getAdjacentOffsets(rule: .queen))
    }

    @Test func euclideanDistance() {
        #expect(AoCCoord2D.origin.distance(to: AoCCoord2D(x: 3, y: 4)) == 5.0)
        #expect(AoCCoord2D(x: 3, y: 4).distance(to: .origin) == 5.0)
        #expect(AoCCoord2D.origin.distance(to: .origin) == 0.0)
        #expect(AoCCoord2D(x: -3, y: -4).distance(to: .origin) == 5.0)
    }

    @Test func manhattanDistance() {
        #expect(AoCCoord2D.origin.manhattanDistance(to: AoCCoord2D(x: 3, y: 4)) == 7)
        #expect(AoCCoord2D(x: -2, y: 5).manhattanDistance(to: AoCCoord2D(x: 3, y: -5)) == 15)
        #expect(AoCCoord2D.origin.manhattanDistance(to: .origin) == 0)
    }

    @Test func manhattanDistanceIsSymmetric() {
        let a = AoCCoord2D(x: 7, y: -3)
        let b = AoCCoord2D(x: -4, y: 11)
        #expect(a.manhattanDistance(to: b) == b.manhattanDistance(to: a))
    }

    @Test func rookAdjacencyIsEdgesOnly() {
        let c = AoCCoord2D(x: 5, y: 5)
        #expect(c.isAdjacent(to: AoCCoord2D(x: 5, y: 4)))
        #expect(c.isAdjacent(to: AoCCoord2D(x: 6, y: 5)))
        #expect(!c.isAdjacent(to: AoCCoord2D(x: 6, y: 6)))
        #expect(!c.isAdjacent(to: AoCCoord2D(x: 5, y: 7)))
    }

    @Test func bishopAdjacencyIsDiagonalsOnly() {
        let c = AoCCoord2D(x: 5, y: 5)
        #expect(c.isAdjacent(to: AoCCoord2D(x: 6, y: 6), rule: .bishop))
        #expect(c.isAdjacent(to: AoCCoord2D(x: 4, y: 6), rule: .bishop))
        #expect(!c.isAdjacent(to: AoCCoord2D(x: 5, y: 6), rule: .bishop))
        #expect(!c.isAdjacent(to: AoCCoord2D(x: 7, y: 7), rule: .bishop))
    }

    @Test func queenAdjacencyIsEdgesAndDiagonals() {
        let c = AoCCoord2D(x: 5, y: 5)
        #expect(c.isAdjacent(to: AoCCoord2D(x: 5, y: 6), rule: .queen))
        #expect(c.isAdjacent(to: AoCCoord2D(x: 4, y: 4), rule: .queen))
        #expect(!c.isAdjacent(to: AoCCoord2D(x: 7, y: 5), rule: .queen))
    }

    @Test func aCoordIsNeverAdjacentToItself() {
        let c = AoCCoord2D(x: 2, y: 2)
        for rule in [AoCAdjacencyRule.rook, .bishop, .queen] {
            #expect(!c.isAdjacent(to: c, rule: rule))
        }
    }

    @Test func adjacencyAgreesWithTheOffsetLists() {
        let c = AoCCoord2D(x: 10, y: -4)
        for rule in [AoCAdjacencyRule.rook, .bishop, .queen] {
            for neighbour in c.getAdjacentCoords(rule: rule) {
                #expect(c.isAdjacent(to: neighbour, rule: rule))
            }
        }
    }

    @Test func getAdjacentCoordsOffsetsFromTheReceiver() {
        let c = AoCCoord2D(x: 1, y: 1)
        #expect(Set(c.getAdjacentCoords()) == Set([AoCCoord2D(x: 1, y: 0), AoCCoord2D(x: 2, y: 1),
                                                   AoCCoord2D(x: 1, y: 2), AoCCoord2D(x: 0, y: 1)]))
        #expect(c.getAdjacentCoords(rule: .queen).count == 8)
        #expect(!c.getAdjacentCoords(rule: .queen).contains(c))
    }

    @Test func offsetByDirectionMovesOneStep() {
        let c = AoCCoord2D(x: 4, y: 4)
        #expect(c.offset(direction: .north) == AoCCoord2D(x: 4, y: 3))
        #expect(c.offset(direction: .se) == AoCCoord2D(x: 5, y: 5))
        for dir in AoCDir.allCases {
            #expect(c.offset(direction: dir) == c + dir.offset)
        }
    }

    @Test func directionToAnotherCoord() {
        let c = AoCCoord2D.origin
        #expect(c.direction(to: AoCCoord2D(x: 0, y: -5)) == .north)
        #expect(c.direction(to: AoCCoord2D(x: 0, y: 5)) == .south)
        #expect(c.direction(to: AoCCoord2D(x: 5, y: 0)) == .east)
        #expect(c.direction(to: AoCCoord2D(x: -5, y: 0)) == .west)
        #expect(c.direction(to: AoCCoord2D(x: -1, y: -1)) == .nw)
        #expect(c.direction(to: AoCCoord2D(x: 1, y: -1)) == .ne)
        #expect(c.direction(to: AoCCoord2D(x: -1, y: 1)) == .sw)
        #expect(c.direction(to: AoCCoord2D(x: 1, y: 1)) == .se)
    }

    @Test func directionToSelfIsNil() {
        let c = AoCCoord2D(x: 3, y: 3)
        #expect(c.direction(to: c) == nil)
    }

    /// Documented behaviour: anything off-axis snaps to the nearest diagonal,
    /// however shallow the angle.
    @Test func directionToSnapsOffAxisTargetsToADiagonal() {
        #expect(AoCCoord2D.origin.direction(to: AoCCoord2D(x: 100, y: -1)) == .ne)
        #expect(AoCCoord2D.origin.direction(to: AoCCoord2D(x: -1, y: 100)) == .sw)
    }

    @Test func directionAndOffsetRoundTripForEveryNeighbour() {
        let c = AoCCoord2D(x: -6, y: 9)
        for dir in AoCDir.allCases {
            #expect(c.direction(to: c.offset(direction: dir)) == dir)
        }
    }

    @Test func descriptionIsBracketedXThenY() {
        #expect(AoCCoord2D(x: 3, y: -4).description == "[3,-4]")
        #expect(AoCCoord2D(x: 3, y: -4).debugDescription == "[3,-4]")
    }
}

@Suite("AoCCoord3D")
struct AoCCoord3DTests {

    @Test func originIsZeroZeroZero() {
        #expect(AoCCoord3D.origin == AoCCoord3D(x: 0, y: 0, z: 0))
    }

    @Test func doubleAccessorsConvertEachComponent() {
        let c = AoCCoord3D(x: 1, y: -2, z: 3)
        #expect(c.dblX == 1.0)
        #expect(c.dblY == -2.0)
        #expect(c.dblZ == 3.0)
    }

    @Test func additionAndSubtraction() {
        let a = AoCCoord3D(x: 1, y: 2, z: 3)
        let b = AoCCoord3D(x: 10, y: -20, z: 30)
        #expect(a + b == AoCCoord3D(x: 11, y: -18, z: 33))
        #expect(a - b == AoCCoord3D(x: -9, y: 22, z: -27))
        #expect(a - a == AoCCoord3D.origin)
    }

    @Test func equalAndUnequalCoordsHashConsistently() {
        let set: Set<AoCCoord3D> = [AoCCoord3D(x: 1, y: 2, z: 3),
                                    AoCCoord3D(x: 1, y: 2, z: 3),
                                    AoCCoord3D(x: 3, y: 2, z: 1)]
        #expect(set.count == 2)
    }

    @Test func manhattanDistance() {
        #expect(AoCCoord3D.origin.manhattanDistance(to: AoCCoord3D(x: 1, y: 2, z: 3)) == 6)
        #expect(AoCCoord3D(x: -1, y: -1, z: -1).manhattanDistance(to: AoCCoord3D(x: 1, y: 1, z: 1)) == 6)
        #expect(AoCCoord3D.origin.manhattanDistance(to: .origin) == 0)
    }

    @Test func rookOffsetsAreTheSixFaces() {
        let offsets = AoCCoord3D.getAdjacentOffsets(rule: .rook)
        #expect(offsets.count == 6)
        #expect(Set(offsets) == Set(AoCDir3D.allCases.map { $0.offset }))
        #expect(AoCCoord3D.getAdjacentOffsets() == offsets)
    }

    @Test func bishopOffsetsAreTheEightCorners() {
        let offsets = AoCCoord3D.getAdjacentOffsets(rule: .bishop)
        #expect(offsets.count == 8)
        #expect(Set(offsets).count == 8)
        #expect(offsets.allSatisfy { abs($0.x) == 1 && abs($0.y) == 1 && abs($0.z) == 1 })
    }

    @Test func queenOffsetsAreTheFacesPlusTheCorners() {
        let offsets = AoCCoord3D.getAdjacentOffsets(rule: .queen)
        #expect(offsets.count == 14)
        #expect(Set(offsets) == Set(AoCCoord3D.getAdjacentOffsets(rule: .rook))
                                .union(Set(AoCCoord3D.getAdjacentOffsets(rule: .bishop))))
        // Edge-sharing cells (two axes) belong to neither rule.
        #expect(!offsets.contains(AoCCoord3D(x: 1, y: 1, z: 0)))
    }

    @Test func adjacencyAgreesWithTheOffsetListsForEveryRule() {
        let c = AoCCoord3D(x: 4, y: -2, z: 7)
        for rule in [AoCAdjacencyRule.rook, .bishop, .queen] {
            let neighbours = c.getAdjacentCoords(rule: rule)
            #expect(!neighbours.isEmpty)
            for neighbour in neighbours {
                #expect(c.isAdjacent(to: neighbour, rule: rule))
            }
        }
    }

    @Test func rookAdjacencyIsFaceSharing() {
        let c = AoCCoord3D(x: 5, y: 5, z: 5)
        #expect(c.isAdjacent(to: AoCCoord3D(x: 5, y: 5, z: 6)))
        #expect(c.isAdjacent(to: AoCCoord3D(x: 4, y: 5, z: 5)))
        #expect(!c.isAdjacent(to: AoCCoord3D(x: 6, y: 6, z: 5)))
        #expect(!c.isAdjacent(to: c))
    }

    @Test func bishopAdjacencyRequiresAStepOnAllThreeAxes() {
        let c = AoCCoord3D(x: 5, y: 5, z: 5)
        #expect(c.isAdjacent(to: AoCCoord3D(x: 6, y: 6, z: 6), rule: .bishop))
        #expect(c.isAdjacent(to: AoCCoord3D(x: 4, y: 6, z: 4), rule: .bishop))
        #expect(!c.isAdjacent(to: AoCCoord3D(x: 6, y: 6, z: 5), rule: .bishop))
        #expect(!c.isAdjacent(to: AoCCoord3D(x: 5, y: 5, z: 6), rule: .bishop))
    }

    @Test func queenAdjacencyIsFacesOrFullDiagonals() {
        let c = AoCCoord3D(x: 5, y: 5, z: 5)
        #expect(c.isAdjacent(to: AoCCoord3D(x: 5, y: 5, z: 6), rule: .queen))
        #expect(c.isAdjacent(to: AoCCoord3D(x: 6, y: 6, z: 6), rule: .queen))
        // Edge-sharing (two axes) is covered by neither rule.
        #expect(!c.isAdjacent(to: AoCCoord3D(x: 6, y: 6, z: 5), rule: .queen))
    }

    @Test func getAdjacentCoordsOffsetsFromTheReceiver() {
        let c = AoCCoord3D(x: 2, y: 2, z: 2)
        let neighbours = c.getAdjacentCoords()
        #expect(neighbours.count == 6)
        #expect(Set(neighbours).count == 6)
        for n in neighbours {
            #expect(c.isAdjacent(to: n))
        }
    }

    @Test func offsetByDirectionMovesOneStep() {
        let c = AoCCoord3D(x: 1, y: 1, z: 1)
        #expect(c.offset(direction: .up) == AoCCoord3D(x: 1, y: 1, z: 2))
        #expect(c.offset(direction: .forward) == AoCCoord3D(x: 1, y: 0, z: 1))
        for dir in AoCDir3D.allCases {
            #expect(c.offset(direction: dir) == c + dir.offset)
        }
    }

    @Test func descriptionIsBracketedXYZ() {
        #expect(AoCCoord3D(x: 1, y: -2, z: 3).description == "[1,-2,3]")
        #expect(AoCCoord3D(x: 1, y: -2, z: 3).debugDescription == "[1,-2,3]")
    }
}

@Suite("AoCPos2D")
struct AoCPos2DTests {

    @Test func turningRotatesInPlace() {
        let pos = AoCPos2D(location: AoCCoord2D(x: 3, y: 3), direction: .north)
        let turned = pos.turned(.right)
        #expect(turned.location == pos.location)
        #expect(turned.direction == .east)
        #expect(pos.turned(.left).direction == .west)
        #expect(pos.turned(.none).direction == .north)
    }

    @Test func turningADirectionlessPositionIsANoOp() {
        let pos = AoCPos2D(location: AoCCoord2D(x: 1, y: 1), direction: nil)
        #expect(pos.turned(.right) == pos)
        #expect(pos.turned(.left) == pos)
    }

    @Test func movingForwardOneStepByDefault() {
        let pos = AoCPos2D(location: AoCCoord2D(x: 5, y: 5), direction: .north)
        let moved = pos.movedForward()
        #expect(moved.location == AoCCoord2D(x: 5, y: 4))
        #expect(moved.direction == .north)
    }

    @Test func movingForwardMultipleSteps() {
        let pos = AoCPos2D(location: AoCCoord2D(x: 0, y: 0), direction: .se)
        #expect(pos.movedForward(distance: 3).location == AoCCoord2D(x: 3, y: 3))
        #expect(pos.movedForward(distance: 0).location == AoCCoord2D(x: 0, y: 0))
        #expect(pos.movedForward(distance: -2).location == AoCCoord2D(x: -2, y: -2))
    }

    @Test func movingADirectionlessPositionIsANoOp() {
        let pos = AoCPos2D(location: AoCCoord2D(x: 1, y: 1), direction: nil)
        #expect(pos.movedForward(distance: 10) == pos)
    }

    @Test func aRoundTripReturnsToTheStartingLocation() {
        let start = AoCPos2D(location: AoCCoord2D(x: 4, y: 7), direction: .east)
        let there = start.movedForward(distance: 6)
        let back = there.turned(.right).turned(.right).movedForward(distance: 6)
        #expect(back.location == start.location)
        #expect(back.direction == .west)
    }

    @Test func positionsHashOnLocationAndDirection() {
        let a = AoCPos2D(location: AoCCoord2D(x: 1, y: 1), direction: .north)
        let b = AoCPos2D(location: AoCCoord2D(x: 1, y: 1), direction: .south)
        let c = AoCPos2D(location: AoCCoord2D(x: 1, y: 1), direction: nil)
        #expect(Set([a, b, c, a]).count == 3)
    }

    @Test func description() {
        #expect(AoCPos2D(location: AoCCoord2D(x: 2, y: 3), direction: .ne).description == "{[2,3] NE}")
        #expect(AoCPos2D(location: AoCCoord2D(x: 2, y: 3), direction: nil).description == "{[2,3] None}")
        #expect(AoCPos2D(location: AoCCoord2D(x: 2, y: 3), direction: .ne).debugDescription == "{[2,3] NE}")
    }
}
