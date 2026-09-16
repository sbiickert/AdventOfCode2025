//
//  AoCGrid2DTests.swift
//  AoCLibraryTests
//

import Testing
import Foundation

@Suite("AoCGrid2D: loading and values")
struct AoCGrid2DValueTests {

    @Test func aNewGridIsEmpty() {
        let grid = AoCGrid2D()
        #expect(grid.defaultValue == ".")
        #expect(grid.rule == .rook)
        #expect(grid.extent == nil)
        #expect(grid.isTiledInfinitely == false)
        #expect(grid.coords.isEmpty)
        #expect(grid.values.isEmpty)
        #expect(grid.stringValue(at: .origin) == ".")
    }

    @Test func initTakesADefaultValueAndAnAdjacencyRule() {
        let grid = AoCGrid2D(defaultValue: " ", rule: .queen)
        #expect(grid.defaultValue == " ")
        #expect(grid.rule == .queen)
        #expect(grid.stringValue(at: AoCCoord2D(x: 99, y: 99)) == " ")
    }

    @Test func loadStoresOnlyNonDefaultCells() {
        let grid = makeGrid(["..#",
                             ".#.",
                             "#.."])
        #expect(grid.coords.count == 3)
        #expect(Set(grid.coords) == Set([AoCCoord2D(x: 2, y: 0),
                                         AoCCoord2D(x: 1, y: 1),
                                         AoCCoord2D(x: 0, y: 2)]))
        #expect(grid.stringValue(at: AoCCoord2D(x: 2, y: 0)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 0, y: 0)) == ".")
    }

    @Test func loadUsesColumnForXAndRowForY() {
        let grid = makeGrid(["...",
                             "..#"])
        #expect(grid.stringValue(at: AoCCoord2D(x: 2, y: 1)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 1, y: 2)) == ".")
    }

    /// Default cells are not stored, but the extent still covers the whole input,
    /// including a border made entirely of the default character.
    @Test func extentCoversTheWholeInput() {
        let grid = makeGrid(["....",
                             ".##.",
                             "...."])
        let ext = try! #require(grid.extent)
        #expect(ext == AoCExtent2D.build(0, 0, 3, 2))
        #expect(ext.width == 4)
        #expect(ext.height == 3)
        #expect(grid.coords.count == 2)
        #expect(grid.histogram == ["#": 2, ".": 10])
    }

    @Test func extentCoversTheWholeInputEvenWhenNothingIsStored() {
        let grid = makeGrid(["...",
                             "..."])
        #expect(grid.extent == AoCExtent2D.build(0, 0, 2, 1))
        #expect(grid.coords.isEmpty)
        #expect(grid.histogram == [".": 6])
    }

    @Test func loadingNoRowsLeavesTheGridEmpty() {
        #expect(makeGrid([]).extent == nil)
        #expect(makeGrid([""]).extent == nil)
    }

    @Test func loadHandlesRaggedRows() {
        let grid = makeGrid(["#",
                             "..#",
                             ".#"])
        #expect(grid.extent == AoCExtent2D.build(0, 0, 2, 2))
    }

    @Test func settingAValueGrowsTheExtent() {
        let grid = AoCGrid2D()
        grid.setValue("A", at: AoCCoord2D(x: 3, y: 3))
        #expect(grid.extent == AoCExtent2D.build(3, 3, 3, 3))
        grid.setValue("B", at: AoCCoord2D(x: -1, y: 5))
        #expect(grid.extent == AoCExtent2D.build(-1, 3, 3, 5))
        grid.setValue("C", at: AoCCoord2D(x: 0, y: 4))
        #expect(grid.extent == AoCExtent2D.build(-1, 3, 3, 5))
    }

    @Test func settingAValueTwiceOverwritesIt() {
        let grid = AoCGrid2D()
        let c = AoCCoord2D(x: 1, y: 1)
        grid.setValue("A", at: c)
        grid.setValue("B", at: c)
        #expect(grid.stringValue(at: c) == "B")
        #expect(grid.coords.count == 1)
    }

    @Test func nonStringValuesAreStoredAndRenderedByInterpolation() {
        let grid = AoCGrid2D()
        let c = AoCCoord2D(x: 0, y: 0)
        grid.setValue(42, at: c)
        #expect(grid.value(at: c) as? Int == 42)
        #expect(grid.stringValue(at: c) == "42")
    }

    @Test func renderableValuesAreDrawnWithTheirGlyph() {
        let grid = AoCGrid2D()
        let c = AoCCoord2D(x: 0, y: 0)
        grid.setValue(TestGlyph(glyph: "@"), at: c)
        #expect(grid.value(at: c) as? TestGlyph == TestGlyph(glyph: "@"))
        #expect(grid.stringValue(at: c) == "@")
    }

    @Test func unsetCellsReturnTheDefaultValue() {
        let grid = makeGrid(["#"])
        #expect(grid.stringValue(at: AoCCoord2D(x: 100, y: -100)) == ".")
        #expect(grid.value(at: AoCCoord2D(x: 100, y: -100)) as? String == ".")
    }

    @Test func valuesReturnsOneEntryPerStoredCell() {
        let grid = makeGrid(["#.#",
                             ".#."])
        #expect(grid.values.count == 3)
        #expect(grid.values.compactMap { $0 as? String } == ["#", "#", "#"])
    }

    @Test func getCoordsFindsCellsByRenderedValue() {
        let grid = makeGrid(["A.B",
                             "B.A"])
        #expect(Set(grid.getCoords(withValue: "A")) == Set([AoCCoord2D(x: 0, y: 0), AoCCoord2D(x: 2, y: 1)]))
        #expect(Set(grid.getCoords(withValue: "B")) == Set([AoCCoord2D(x: 2, y: 0), AoCCoord2D(x: 0, y: 1)]))
    }

    /// Default-valued cells are never stored, so they are invisible to getCoords.
    @Test func getCoordsNeverReturnsDefaultCells() {
        let grid = makeGrid(["A.B"])
        #expect(grid.getCoords(withValue: ".").isEmpty)
        #expect(grid.getCoords(withValue: "Z").isEmpty)
    }

    @Test func getCoordsMatchesRenderableAndNumericValues() {
        let grid = AoCGrid2D()
        grid.setValue(7, at: AoCCoord2D(x: 0, y: 0))
        grid.setValue(TestGlyph(glyph: "@"), at: AoCCoord2D(x: 1, y: 0))
        #expect(grid.getCoords(withValue: "7") == [AoCCoord2D(x: 0, y: 0)])
        #expect(grid.getCoords(withValue: "@") == [AoCCoord2D(x: 1, y: 0)])
    }

    @Test func histogramCountsEveryCellInsideTheExtent() {
        let grid = makeGrid(["..#",
                             ".#.",
                             "#.."])
        #expect(grid.histogram == ["#": 3, ".": 6])
    }

    @Test func histogramOfAnEmptyGridIsEmpty() {
        #expect(AoCGrid2D().histogram.isEmpty)
    }

    @Test func histogramTotalsTheExtentArea() {
        let grid = makeGrid(["#ab",
                             "cd#"])
        let ext = try! #require(grid.extent)
        #expect(grid.histogram.values.reduce(0, +) == ext.area)
    }

    @Test func clearRemovesACellButKeepsTheExtentByDefault() {
        let grid = makeGrid(["#.#",
                             "...",
                             "#.#"])
        let before = grid.extent
        grid.clear(at: AoCCoord2D(x: 2, y: 2))
        #expect(grid.stringValue(at: AoCCoord2D(x: 2, y: 2)) == ".")
        #expect(grid.coords.count == 3)
        #expect(grid.extent == before)
    }

    @Test func clearCanRecomputeTheExtent() {
        let grid = makeGrid(["#.#",
                             "...",
                             "#.#"])
        grid.clear(at: AoCCoord2D(x: 2, y: 2), resetExtent: true)
        #expect(grid.extent == AoCExtent2D.build(0, 0, 2, 2))
        grid.clear(at: AoCCoord2D(x: 2, y: 0), resetExtent: true)
        #expect(grid.extent == AoCExtent2D.build(0, 0, 0, 2))
    }

    @Test func clearingACellThatWasNeverSetIsHarmless() {
        let grid = makeGrid(["#"])
        grid.clear(at: AoCCoord2D(x: 50, y: 50))
        #expect(grid.coords.count == 1)
    }
}

@Suite("AoCGrid2D: neighbours")
struct AoCGrid2DNeighbourTests {

    @Test func neighbourOffsetsFollowTheGridsRule() {
        #expect(makeGrid(["#"], rule: .rook).neighbourOffsets.count == 4)
        #expect(makeGrid(["#"], rule: .bishop).neighbourOffsets.count == 4)
        #expect(makeGrid(["#"], rule: .queen).neighbourOffsets.count == 8)
        #expect(makeGrid(["#"], rule: .queen).neighbourOffsets
                == AoCCoord2D.getAdjacentOffsets(rule: .queen))
    }

    @Test func neighbourCoordsAreNotClippedToTheExtent() {
        let grid = makeGrid(["#"])
        let neighbours = grid.neighbourCoords(at: .origin)
        #expect(neighbours.count == 4)
        #expect(neighbours.contains(AoCCoord2D(x: 0, y: -1)))
        #expect(neighbours.contains(AoCCoord2D(x: -1, y: 0)))
    }

    @Test func neighbourCoordsFilteredByValue() {
        let grid = makeGrid(["..#",
                             ".#.",
                             "#.."])
        let hashes = grid.neighbourCoords(at: AoCCoord2D(x: 1, y: 0), withValue: "#")
        #expect(Set(hashes) == Set([AoCCoord2D(x: 2, y: 0), AoCCoord2D(x: 1, y: 1)]))
    }

    @Test func filteringByTheDefaultValueIncludesCellsOutsideTheExtent() {
        let grid = makeGrid(["#"])
        #expect(grid.neighbourCoords(at: .origin, withValue: ".").count == 4)
    }

    @Test func queenNeighboursIncludeDiagonals() {
        let grid = makeGrid(["#.#",
                             ".X.",
                             "#.#"], rule: .queen)
        let centre = AoCCoord2D(x: 1, y: 1)
        #expect(grid.neighbourCoords(at: centre).count == 8)
        #expect(grid.neighbourCoords(at: centre, withValue: "#").count == 4)
    }

    @Test func rookNeighboursExcludeDiagonals() {
        let grid = makeGrid(["#.#",
                             ".X.",
                             "#.#"], rule: .rook)
        #expect(grid.neighbourCoords(at: AoCCoord2D(x: 1, y: 1), withValue: "#").isEmpty)
    }
}

@Suite("AoCGrid2D: rendering")
struct AoCGrid2DRenderingTests {

    @Test func toStringDrawsTheExtentSpaceSeparated() {
        let grid = makeGrid(["#.#",
                             ".#.",
                             "#.#"])
        #expect(grid.toString() == "# . #\n. # .\n# . #\n")
    }

    @Test func toStringOfAnEmptyGridIsEmpty() {
        #expect(AoCGrid2D().toString() == "")
    }

    @Test func toStringOnlyDrawsTheExtent() {
        let grid = AoCGrid2D()
        grid.setValue("#", at: AoCCoord2D(x: 5, y: 5))
        #expect(grid.toString() == "#\n")
    }

    @Test func markersOverrideTheStoredValues() {
        let grid = makeGrid(["#.",
                             ".#"])
        let markers = [AoCCoord2D(x: 0, y: 0): "A", AoCCoord2D(x: 1, y: 0): "B"]
        #expect(grid.toString(markers: markers) == "A B\n. #\n")
    }

    @Test func markersOutsideTheExtentAreNotDrawn() {
        let grid = makeGrid(["#"])
        #expect(grid.toString(markers: [AoCCoord2D(x: 9, y: 9): "!"]) == "#\n")
    }

    @Test func aDrawExtentIsOnlyHonouredForTiledGrids() {
        let grid = makeGrid(["#.",
                             ".#"])
        let wider = AoCExtent2D.build(0, 0, 3, 1)
        // Not tiled: the draw extent is ignored.
        #expect(grid.toString(drawExtent: wider) == "# .\n. #\n")

        grid.isTiledInfinitely = true
        #expect(grid.toString(drawExtent: wider) == "# . # .\n. # . #\n")
    }
}

@Suite("AoCGrid2D: infinite tiling")
struct AoCGrid2DTilingTests {

    /// Tiling wraps with `trueMod` of the raw coordinate, so it assumes the grid
    /// starts at the origin.
    private func tiledGrid() -> AoCGrid2D {
        let grid = makeGrid(["#..",
                             "...",
                             "..#"])
        grid.isTiledInfinitely = true
        return grid
    }

    @Test func theSampleGridSpansTheOrigin() {
        #expect(tiledGrid().extent == AoCExtent2D.build(0, 0, 2, 2))
    }

    @Test func coordsInsideTheExtentAreUnaffected() {
        let grid = tiledGrid()
        #expect(grid.stringValue(at: AoCCoord2D(x: 0, y: 0)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 2, y: 2)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 1, y: 1)) == ".")
    }

    @Test func coordsPastTheEastAndSouthEdgesWrap() {
        let grid = tiledGrid()
        #expect(grid.stringValue(at: AoCCoord2D(x: 3, y: 3)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 3, y: 0)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 30, y: 30)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 4, y: 4)) == ".")
    }

    @Test func coordsPastTheWestAndNorthEdgesWrap() {
        let grid = tiledGrid()
        #expect(grid.stringValue(at: AoCCoord2D(x: -1, y: -1)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: -3, y: -3)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: -2, y: -2)) == ".")
    }

    @Test func tilingIsPeriodicInBothAxes() {
        let grid = tiledGrid()
        let ext = try! #require(grid.extent)
        for coord in ext.allCoords {
            let shifted = AoCCoord2D(x: coord.x + 3 * ext.width, y: coord.y - 2 * ext.height)
            #expect(grid.stringValue(at: shifted) == grid.stringValue(at: coord))
        }
    }

    /// Wrapping is relative to the extent's own origin, so a grid that does not
    /// start at [0,0] still tiles correctly.
    @Test func tilingWorksForGridsAwayFromTheOrigin() {
        let grid = AoCGrid2D()
        grid.setValue("#", at: AoCCoord2D(x: 10, y: 20))
        grid.setValue("@", at: AoCCoord2D(x: 12, y: 22))
        grid.isTiledInfinitely = true
        #expect(grid.extent == AoCExtent2D.build(10, 20, 12, 22))

        // One full period east and south of each stored cell.
        #expect(grid.stringValue(at: AoCCoord2D(x: 13, y: 23)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 15, y: 25)) == "@")
        // One full period west and north.
        #expect(grid.stringValue(at: AoCCoord2D(x: 7, y: 17)) == "#")
        #expect(grid.stringValue(at: AoCCoord2D(x: 9, y: 19)) == "@")
        #expect(grid.stringValue(at: AoCCoord2D(x: 14, y: 24)) == ".")
    }

    @Test func tiledLookupsArePeriodicForAnOffsetGrid() {
        let grid = makeGrid(["#..",
                             "...",
                             "..@"])
        grid.setValue("#", at: AoCCoord2D(x: 5, y: 5))
        grid.isTiledInfinitely = true
        let ext = try! #require(grid.extent)
        for coord in ext.allCoords {
            let shifted = AoCCoord2D(x: coord.x + 2 * ext.width, y: coord.y - 3 * ext.height)
            #expect(grid.stringValue(at: shifted) == grid.stringValue(at: coord))
        }
    }

    @Test func withoutTilingOutOfBoundsCoordsAreTheDefaultValue() {
        let grid = makeGrid(["#..",
                             "...",
                             "..#"])
        #expect(grid.stringValue(at: AoCCoord2D(x: 3, y: 3)) == ".")
        #expect(grid.stringValue(at: AoCCoord2D(x: -1, y: -1)) == ".")
    }
}

@Suite("AoCGrid2D: flood fill")
struct AoCGrid2DFillTests {

    @Test func fillingAnEnclosedRegionPaintsEveryInteriorCell() {
        let grid = makeGrid(["#####",
                             "#...#",
                             "#...#",
                             "#...#",
                             "#####"])
        var filled = [AoCCoord2D]()
        let escaped = grid.fill(with: "O", at: AoCCoord2D(x: 2, y: 2), filled: &filled)

        #expect(escaped == false)
        // Each cell is recorded exactly once, so `filled.count` is the area.
        #expect(filled.count == 9)
        #expect(Set(filled).count == 9)
        #expect(grid.getCoords(withValue: "O").count == 9)
        #expect(grid.getCoords(withValue: "#").count == 16)
        #expect(grid.histogram == ["#": 16, "O": 9])
    }

    @Test func fillOnlyReachesCellsConnectedByTheAdjacencyRule() {
        // Two interior rooms separated by a wall: filling one leaves the other.
        let grid = makeGrid(["#####",
                             "#.#.#",
                             "#####"])
        var filled = [AoCCoord2D]()
        let escaped = grid.fill(with: "O", at: AoCCoord2D(x: 1, y: 1), filled: &filled)

        #expect(escaped == false)
        #expect(filled == [AoCCoord2D(x: 1, y: 1)])
        #expect(grid.stringValue(at: AoCCoord2D(x: 3, y: 1)) == ".")
    }

    @Test func fillStartingOutsideTheExtentReportsEscapeAndChangesNothing() {
        let grid = makeGrid(["###",
                             "#.#",
                             "###"])
        var filled = [AoCCoord2D]()
        let escaped = grid.fill(with: "O", at: AoCCoord2D(x: 99, y: 99), filled: &filled)

        #expect(escaped == true)
        #expect(filled.isEmpty)
        #expect(grid.getCoords(withValue: "O").isEmpty)
        #expect(grid.coords.count == 8)
    }

    /// A region with a gap in its wall leaks to infinity: `fill` reports `true`
    /// and rolls back every cell it painted. This is the "is this region closed?"
    /// query the puzzles use it for.
    @Test func fillingALeakyRegionReportsEscapeAndRollsBack() {
        let grid = makeGrid(["#####",
                             "#...#",
                             "#....",
                             "#...#",
                             "#####"])
        var filled = [AoCCoord2D]()
        let escaped = grid.fill(with: "O", at: AoCCoord2D(x: 2, y: 2), filled: &filled)

        #expect(escaped == true)
        #expect(!filled.isEmpty)
        #expect(grid.getCoords(withValue: "O").isEmpty)
        #expect(grid.getCoords(withValue: "#").count == 15)
    }

    @Test func fillingAnEmptyGridEscapesWithoutTrapping() {
        let grid = AoCGrid2D()
        var filled = [AoCCoord2D]()
        #expect(grid.fill(with: "O", at: .origin, filled: &filled) == true)
        #expect(filled.isEmpty)
        #expect(grid.coords.isEmpty)
    }

    @Test func fillingACellThatAlreadyHasTheFillValueIsANoOp() {
        let grid = makeGrid(["#####",
                             "#...#",
                             "#####"])
        var first = [AoCCoord2D]()
        #expect(grid.fill(with: "O", at: AoCCoord2D(x: 1, y: 1), filled: &first) == false)
        #expect(first.count == 3)

        var second = [AoCCoord2D]()
        #expect(grid.fill(with: "O", at: AoCCoord2D(x: 1, y: 1), filled: &second) == false)
        #expect(second.isEmpty)
        #expect(grid.getCoords(withValue: "O").count == 3)
    }

    /// Starting on a cell at the edge of the extent escapes immediately, because
    /// the neighbour just outside the extent still reports the default value.
    @Test func fillingFromTheExtentEdgeEscapes() {
        let grid = makeGrid(["###",
                             "#.#",
                             "###"])
        var filled = [AoCCoord2D]()
        let escaped = grid.fill(with: "O", at: AoCCoord2D(x: 0, y: 0), filled: &filled)

        #expect(escaped == true)
        #expect(filled == [AoCCoord2D(x: 0, y: 0)])
        // The rollback removed the start cell from the grid entirely.
        #expect(grid.stringValue(at: AoCCoord2D(x: 0, y: 0)) == ".")
        #expect(grid.coords.count == 7)
    }
}
