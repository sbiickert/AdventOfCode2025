//
//  TestSupport.swift
//  AoCLibraryTests
//
//  Shared helpers for the AoC library test suites.
//

import Foundation

/// A value that renders itself in a grid through `AoCGridRenderable`.
struct TestGlyph: AoCGridRenderable, Equatable {
    let glyph: String
}

/// A solution stub that does not read any files, for exercising AoCInput/AoCSolution
/// without depending on the contents of the real puzzle-input folder.
final class StubSolution: AoCSolution {
    init(day: Int, multipleInputs: Bool) {
        super.init()
        self.day = day
        self.name = "Stub"
        self.emptyLinesIndicateMultipleInputs = multipleInputs
    }
}

/// Builds a grid from rows of text, mirroring how the solutions load puzzle input.
func makeGrid(_ rows: [String],
              defaultValue: String = ".",
              rule: AoCAdjacencyRule = .rook) -> AoCGrid2D {
    let grid = AoCGrid2D(defaultValue: defaultValue, rule: rule)
    grid.load(data: rows)
    return grid
}
