//
//  AoCExtent2DTests.swift
//  AoCLibraryTests
//

import Testing
import Foundation

@Suite("AoCExtent2D: construction")
struct AoCExtent2DConstructionTests {

    @Test func buildFromCoordsSpansThemAll() {
        let coords = [AoCCoord2D(x: 3, y: -1), AoCCoord2D(x: -2, y: 4), AoCCoord2D(x: 0, y: 0)]
        let ext = try! #require(AoCExtent2D.build(from: coords))
        #expect(ext.min == AoCCoord2D(x: -2, y: -1))
        #expect(ext.max == AoCCoord2D(x: 3, y: 4))
        for c in coords {
            #expect(ext.contains(c))
        }
    }

    @Test func buildFromASingleCoordIsADegenerateExtent() {
        let ext = try! #require(AoCExtent2D.build(from: [AoCCoord2D(x: 7, y: 7)]))
        #expect(ext.min == ext.max)
        #expect(ext.width == 1)
        #expect(ext.height == 1)
        #expect(ext.area == 1)
    }

    @Test func buildFromNoCoordsIsNil() {
        #expect(AoCExtent2D.build(from: []) == nil)
    }

    @Test func buildFromComponentsTakesMinXMinYMaxXMaxY() {
        let ext = AoCExtent2D.build(1, 2, 3, 4)
        #expect(ext.min == AoCCoord2D(x: 1, y: 2))
        #expect(ext.max == AoCCoord2D(x: 3, y: 4))
    }

    @Test func initNormalisesFullySwappedCorners() {
        let ext = AoCExtent2D(min: AoCCoord2D(x: 5, y: 5), max: AoCCoord2D(x: 1, y: 1))
        #expect(ext.min == AoCCoord2D(x: 1, y: 1))
        #expect(ext.max == AoCCoord2D(x: 5, y: 5))
    }

    @Test func initNormalisesPartiallySwappedCorners() {
        let ext = AoCExtent2D(min: AoCCoord2D(x: 5, y: 1), max: AoCCoord2D(x: 1, y: 5))
        #expect(ext.min == AoCCoord2D(x: 1, y: 1))
        #expect(ext.max == AoCCoord2D(x: 5, y: 5))
    }

    @Test func extentsAreValueTypesThatHashOnTheirCorners() {
        let a = AoCExtent2D.build(0, 0, 2, 2)
        let b = AoCExtent2D(min: AoCCoord2D(x: 2, y: 2), max: AoCCoord2D(x: 0, y: 0))
        #expect(a == b)
        #expect(Set([a, b]).count == 1)
    }

    @Test func description() {
        #expect(AoCExtent2D.build(0, 1, 2, 3).description == "{min: [0,1], max: [2,3]}")
        #expect(AoCExtent2D.build(0, 1, 2, 3).debugDescription == "{min: [0,1], max: [2,3]}")
    }
}

@Suite("AoCExtent2D: geometry")
struct AoCExtent2DGeometryTests {

    let ext = AoCExtent2D.build(2, 3, 6, 9)

    @Test func cornersUseScreenOrientation() {
        #expect(ext.nw == AoCCoord2D(x: 2, y: 3))
        #expect(ext.ne == AoCCoord2D(x: 6, y: 3))
        #expect(ext.sw == AoCCoord2D(x: 2, y: 9))
        #expect(ext.se == AoCCoord2D(x: 6, y: 9))
        #expect(ext.nw == ext.min)
        #expect(ext.se == ext.max)
    }

    @Test func extentsAreInclusiveOfBothBounds() {
        #expect(ext.width == 5)
        #expect(ext.height == 7)
        #expect(ext.area == 35)
    }

    @Test func containsIsInclusiveOfTheEdges() {
        #expect(ext.contains(ext.min))
        #expect(ext.contains(ext.max))
        #expect(ext.contains(ext.ne))
        #expect(ext.contains(AoCCoord2D(x: 4, y: 5)))
        #expect(!ext.contains(AoCCoord2D(x: 1, y: 5)))
        #expect(!ext.contains(AoCCoord2D(x: 7, y: 5)))
        #expect(!ext.contains(AoCCoord2D(x: 4, y: 2)))
        #expect(!ext.contains(AoCCoord2D(x: 4, y: 10)))
    }

    @Test func allCoordsEnumeratesEveryCellExactlyOnce() {
        let coords = ext.allCoords
        #expect(coords.count == ext.area)
        #expect(Set(coords).count == ext.area)
        #expect(coords.allSatisfy { ext.contains($0) })
    }

    @Test func allCoordsOfADegenerateExtentIsOneCell() {
        #expect(AoCExtent2D.build(4, 4, 4, 4).allCoords == [AoCCoord2D(x: 4, y: 4)])
    }

    @Test func expandingToFitAnOutsideCoordGrowsTheExtent() {
        let grown = ext.expanded(toFit: AoCCoord2D(x: 10, y: 1))
        #expect(grown.min == AoCCoord2D(x: 2, y: 1))
        #expect(grown.max == AoCCoord2D(x: 10, y: 9))
        #expect(grown.contains(AoCCoord2D(x: 10, y: 1)))
    }

    @Test func expandingToFitAContainedCoordChangesNothing() {
        #expect(ext.expanded(toFit: AoCCoord2D(x: 4, y: 5)) == ext)
        #expect(ext.expanded(toFit: ext.min) == ext)
        #expect(ext.expanded(toFit: ext.max) == ext)
    }

    @Test func expandingIsIdempotent() {
        let c = AoCCoord2D(x: -5, y: -5)
        let once = ext.expanded(toFit: c)
        #expect(once.expanded(toFit: c) == once)
    }

    @Test func insetShrinksOnAllFourSides() {
        let inner = try! #require(AoCExtent2D.build(0, 0, 4, 4).inset(amount: 1))
        #expect(inner == AoCExtent2D.build(1, 1, 3, 3))
        #expect(inner.area == 9)
    }

    @Test func insetDownToASingleCellIsStillValid() {
        #expect(AoCExtent2D.build(0, 0, 4, 4).inset(amount: 2) == AoCExtent2D.build(2, 2, 2, 2))
    }

    @Test func insetTooFarIsNil() {
        #expect(AoCExtent2D.build(0, 0, 4, 4).inset(amount: 3) == nil)
        #expect(AoCExtent2D.build(4, 4, 4, 4).inset(amount: 1) == nil)
    }

    @Test func insetHandlesNonSquareExtents() {
        // Wide but only three rows tall: an inset of 2 fails on the y axis only.
        let wide = AoCExtent2D.build(0, 0, 20, 2)
        #expect(wide.inset(amount: 1) == AoCExtent2D.build(1, 1, 19, 1))
        #expect(wide.inset(amount: 2) == nil)
    }

    @Test func aNegativeInsetExpands() {
        #expect(AoCExtent2D.build(0, 0, 4, 4).inset(amount: -1) == AoCExtent2D.build(-1, -1, 5, 5))
    }

    @Test func insetOfZeroIsUnchanged() {
        #expect(ext.inset(amount: 0) == ext)
    }
}

@Suite("AoCExtent2D: intersect")
struct AoCExtent2DIntersectTests {

    @Test func partialOverlap() {
        let a = AoCExtent2D.build(0, 0, 5, 5)
        let b = AoCExtent2D.build(3, 3, 8, 8)
        #expect(a.intersect(other: b) == AoCExtent2D.build(3, 3, 5, 5))
    }

    @Test func intersectionIsCommutative() {
        let a = AoCExtent2D.build(0, 0, 5, 5)
        let b = AoCExtent2D.build(3, -2, 8, 4)
        #expect(a.intersect(other: b) == b.intersect(other: a))
    }

    @Test func nestedExtentsIntersectToTheInnerOne() {
        let outer = AoCExtent2D.build(0, 0, 10, 10)
        let inner = AoCExtent2D.build(4, 4, 6, 6)
        #expect(outer.intersect(other: inner) == inner)
        #expect(inner.intersect(other: outer) == inner)
    }

    @Test func selfIntersectionIsIdentity() {
        let a = AoCExtent2D.build(1, 2, 3, 4)
        #expect(a.intersect(other: a) == a)
    }

    @Test func extentsTouchingAtACornerShareThatOneCell() {
        let a = AoCExtent2D.build(0, 0, 2, 2)
        let b = AoCExtent2D.build(2, 2, 4, 4)
        #expect(a.intersect(other: b) == AoCExtent2D.build(2, 2, 2, 2))
    }

    @Test func extentsSharingAnEdgeIntersectInThatEdge() {
        let a = AoCExtent2D.build(0, 0, 2, 5)
        let b = AoCExtent2D.build(2, 0, 4, 5)
        #expect(a.intersect(other: b) == AoCExtent2D.build(2, 0, 2, 5))
    }

    @Test func separatedOnXIsNil() {
        #expect(AoCExtent2D.build(0, 0, 2, 2).intersect(other: AoCExtent2D.build(4, 0, 6, 2)) == nil)
    }

    @Test func separatedOnYIsNil() {
        #expect(AoCExtent2D.build(0, 0, 2, 2).intersect(other: AoCExtent2D.build(0, 4, 2, 6)) == nil)
    }

    @Test func intersectionContainsExactlyTheSharedCells() {
        let a = AoCExtent2D.build(0, 0, 5, 5)
        let b = AoCExtent2D.build(3, 2, 9, 7)
        let shared = Set(a.allCoords).intersection(Set(b.allCoords))
        let result = try! #require(a.intersect(other: b))
        #expect(Set(result.allCoords) == shared)
    }
}

@Suite("AoCExtent2D: union")
struct AoCExtent2DUnionTests {

    @Test func unionOfIdenticalExtentsIsTheExtentItself() {
        let a = AoCExtent2D.build(1, 1, 4, 4)
        #expect(a.union(other: a) == [a])
    }

    @Test func unionOfDisjointExtentsReturnsBothUnchanged() {
        let a = AoCExtent2D.build(0, 0, 2, 2)
        let b = AoCExtent2D.build(10, 10, 12, 12)
        let result = a.union(other: b)
        #expect(result.count == 2)
        #expect(Set(result) == Set([a, b]))
    }

    /// `union` is documented as returning a set of pieces rather than one box, so
    /// the contract that matters is: the pieces cover the same cells as the two
    /// inputs together, and no cell is covered twice.
    @Test(arguments: [
        (AoCExtent2D.build(0, 0, 5, 5), AoCExtent2D.build(3, 3, 8, 8)),   // overlapping corner
        (AoCExtent2D.build(0, 0, 5, 5), AoCExtent2D.build(2, 2, 3, 3)),   // fully contained
        (AoCExtent2D.build(2, 2, 3, 3), AoCExtent2D.build(0, 0, 5, 5)),   // fully containing
        (AoCExtent2D.build(0, 0, 9, 3), AoCExtent2D.build(3, 0, 6, 3)),   // shared top and bottom edge
        (AoCExtent2D.build(0, 0, 9, 9), AoCExtent2D.build(3, 3, 6, 6)),   // ring around the middle
        (AoCExtent2D.build(0, 0, 4, 9), AoCExtent2D.build(2, 3, 8, 6)),   // cross
        (AoCExtent2D.build(0, 0, 2, 2), AoCExtent2D.build(2, 2, 4, 4)),   // touching at one corner
        (AoCExtent2D.build(-4, -4, 0, 0), AoCExtent2D.build(-2, -6, 2, -2)) // negative coordinates
    ])
    func unionPiecesTileTheCombinedAreaExactly(_ c: (a: AoCExtent2D, b: AoCExtent2D)) {
        let pieces = c.a.union(other: c.b)
        let expected = Set(c.a.allCoords).union(Set(c.b.allCoords))

        var covered = Set<AoCCoord2D>()
        var duplicated = Set<AoCCoord2D>()
        for piece in pieces {
            for coord in piece.allCoords {
                if !covered.insert(coord).inserted {
                    duplicated.insert(coord)
                }
            }
        }

        #expect(covered == expected, "pieces cover the wrong cells")
        #expect(duplicated.isEmpty, "\(duplicated.count) cell(s) covered by more than one piece")
    }

    @Test func unionAlwaysCoversBothInputs() {
        let a = AoCExtent2D.build(0, 0, 5, 5)
        let b = AoCExtent2D.build(4, -3, 9, 2)
        let pieces = a.union(other: b)
        for coord in Set(a.allCoords).union(Set(b.allCoords)) {
            #expect(pieces.contains { $0.contains(coord) })
        }
    }

    @Test func unionNeverCoversCellsOutsideTheInputs() {
        let a = AoCExtent2D.build(0, 0, 5, 5)
        let b = AoCExtent2D.build(4, -3, 9, 2)
        let allowed = Set(a.allCoords).union(Set(b.allCoords))
        for piece in a.union(other: b) {
            for coord in piece.allCoords {
                #expect(allowed.contains(coord))
            }
        }
    }
}
