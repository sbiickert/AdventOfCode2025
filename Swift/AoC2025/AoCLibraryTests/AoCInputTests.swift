//
//  AoCInputTests.swift
//  AoCLibraryTests
//

import Testing
import Foundation

@Suite("AoCInput: paths")
struct AoCInputPathTests {

    @Test func fileNamesAreZeroPaddedAndSuffixed() {
        #expect(AoCInput.fileName(day: 1, isTest: true) == "day01_test.txt")
        #expect(AoCInput.fileName(day: 1, isTest: false) == "day01_challenge.txt")
        #expect(AoCInput.fileName(day: 0, isTest: false) == "day00_challenge.txt")
        #expect(AoCInput.fileName(day: 9, isTest: true) == "day09_test.txt")
        #expect(AoCInput.fileName(day: 25, isTest: false) == "day25_challenge.txt")
    }

    @Test func inputFolderIsUnderTheConfiguredYear() {
        #expect(AoCInput.INPUT_FOLDER.hasSuffix("/Input"))
        #expect(AoCInput.INPUT_FOLDER.contains("\(AoCInput.YEAR)"))
    }

    @Test func inputPathExpandsTheTildeAndAppendsTheFileName() {
        let url = AoCInput.inputPath(for: "day07_test.txt")
        #expect(url.isFileURL)
        #expect(!url.path.contains("~"))
        #expect(url.path.hasPrefix("/"))
        #expect(url.lastPathComponent == "day07_test.txt")
        #expect(url.deletingLastPathComponent().lastPathComponent == "Input")
    }

    @Test func theInstancePathMatchesTheStaticHelper() {
        let input = AoCInput(solution: StubSolution(day: 3, multipleInputs: false),
                             fileName: "day03_test.txt",
                             index: 0)
        #expect(input.inputPath == AoCInput.inputPath(for: "day03_test.txt"))
    }

    @Test func idCombinesFileNameAndIndex() {
        let s = StubSolution(day: 1, multipleInputs: false)
        #expect(AoCInput(solution: s, fileName: "day01_test.txt", index: 0).id == "day01_test.txt[0]")
        #expect(AoCInput(solution: s, fileName: "day01_test.txt", index: 2).id == "day01_test.txt[2]")
    }

    /// With single-input solutions no files are read to enumerate the inputs:
    /// one challenge input followed by one test input.
    @Test func inputsForASingleInputSolution() {
        let s = StubSolution(day: 4, multipleInputs: false)
        let inputs = AoCInput.inputsFor(solution: s)
        #expect(inputs.count == 2)
        #expect(inputs[0].fileName == "day04_challenge.txt")
        #expect(inputs[0].index == 0)
        #expect(inputs[1].fileName == "day04_test.txt")
        #expect(inputs[1].index == 0)
    }

    @Test func readingAMissingFileYieldsNothingOnEitherPath() {
        #expect(AoCInput.readInputFile(named: "day98_does_not_exist.txt", removingEmptyLines: true).isEmpty)
        #expect(AoCInput.readInputFile(named: "day98_does_not_exist.txt", removingEmptyLines: false).isEmpty)
    }

    @Test func groupingAMissingFileYieldsNoGroups() {
        #expect(AoCInput.readGroupedInputFile(named: "day98_does_not_exist.txt").isEmpty)
        #expect(AoCInput.readGroupedInputFile(named: "day98_does_not_exist.txt", atIndex: 0).isEmpty)
        #expect(AoCInput.readGroupedInputFile(named: "day98_does_not_exist.txt", atIndex: -1).isEmpty)
    }
}

/// Exercises the file-reading paths against fixtures written into the real input
/// folder. `AoCInput.INPUT_FOLDER` is a `static let` built from `YEAR`, so there
/// is no way to redirect it at runtime; these tests therefore create
/// `day99_test.txt` / `day99_challenge.txt` (days only ever run 1...25) and
/// delete them again afterwards.
@Suite("AoCInput: reading files", .serialized)
final class AoCInputFileTests {

    private static let testFixture = "day99_test.txt"
    private static let challengeFixture = "day99_challenge.txt"
    private static let emptyFixture = "day99_empty.txt"

    private let testFixtureURL = AoCInput.inputPath(for: AoCInputFileTests.testFixture)
    private let challengeFixtureURL = AoCInput.inputPath(for: AoCInputFileTests.challengeFixture)
    private let emptyFixtureURL = AoCInput.inputPath(for: AoCInputFileTests.emptyFixture)

    init() throws {
        let folder = testFixtureURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)

        // Three groups separated by blank lines, plus a trailing newline.
        try "alpha\nbeta\n\ngamma\n\ndelta\nepsilon\nzeta\n"
            .write(to: testFixtureURL, atomically: true, encoding: .utf8)
        // Several stray trailing blank lines, as a copy/paste slip would leave.
        try "a\nb\n\n\n"
            .write(to: challengeFixtureURL, atomically: true, encoding: .utf8)
        try "".write(to: emptyFixtureURL, atomically: true, encoding: .utf8)
    }

    deinit {
        try? FileManager.default.removeItem(at: testFixtureURL)
        try? FileManager.default.removeItem(at: challengeFixtureURL)
        try? FileManager.default.removeItem(at: emptyFixtureURL)
    }

    @Test func anEmptyFileYieldsNoLinesOnEitherPath() {
        #expect(AoCInput.readInputFile(named: Self.emptyFixture, removingEmptyLines: false).isEmpty)
        #expect(AoCInput.readInputFile(named: Self.emptyFixture, removingEmptyLines: true).isEmpty)
    }

    @Test func anEmptyFileHasNoGroups() {
        #expect(AoCInput.readGroupedInputFile(named: Self.emptyFixture).isEmpty)
        #expect(AoCInput.readGroupedInputFile(named: Self.emptyFixture, atIndex: 0).isEmpty)
    }

    @Test func aFileOfOnlyBlankLinesYieldsNoLines() throws {
        let url = AoCInput.inputPath(for: Self.emptyFixture)
        try "\n\n\n".write(to: url, atomically: true, encoding: .utf8)
        #expect(AoCInput.readInputFile(named: Self.emptyFixture, removingEmptyLines: false).isEmpty)
        #expect(AoCInput.readInputFile(named: Self.emptyFixture, removingEmptyLines: true).isEmpty)
    }

    @Test func readingKeepsInteriorBlankLinesButDropsTrailingOnes() {
        let lines = AoCInput.readInputFile(named: Self.testFixture, removingEmptyLines: false)
        #expect(lines == ["alpha", "beta", "", "gamma", "", "delta", "epsilon", "zeta"])
    }

    @Test func readingCanDropEveryBlankLine() {
        let lines = AoCInput.readInputFile(named: Self.testFixture, removingEmptyLines: true)
        #expect(lines == ["alpha", "beta", "gamma", "delta", "epsilon", "zeta"])
    }

    @Test func repeatedTrailingBlankLinesAreAllRemoved() {
        #expect(AoCInput.readInputFile(named: Self.challengeFixture, removingEmptyLines: false) == ["a", "b"])
        #expect(AoCInput.readInputFile(named: Self.challengeFixture, removingEmptyLines: true) == ["a", "b"])
    }

    @Test func blankLinesSplitTheFileIntoGroups() {
        let groups = AoCInput.readGroupedInputFile(named: Self.testFixture)
        #expect(groups.count == 3)
        #expect(groups[0] == ["alpha", "beta"])
        #expect(groups[1] == ["gamma"])
        #expect(groups[2] == ["delta", "epsilon", "zeta"])
    }

    @Test func aFileWithNoBlankLinesIsASingleGroup() {
        let groups = AoCInput.readGroupedInputFile(named: Self.challengeFixture)
        #expect(groups == [["a", "b"]])
    }

    @Test func groupsCanBeAddressedByIndex() {
        #expect(AoCInput.readGroupedInputFile(named: Self.testFixture, atIndex: 0) == ["alpha", "beta"])
        #expect(AoCInput.readGroupedInputFile(named: Self.testFixture, atIndex: 1) == ["gamma"])
        #expect(AoCInput.readGroupedInputFile(named: Self.testFixture, atIndex: 2) == ["delta", "epsilon", "zeta"])
    }

    @Test func anOutOfRangeGroupIndexIsEmpty() {
        #expect(AoCInput.readGroupedInputFile(named: Self.testFixture, atIndex: 3).isEmpty)
        #expect(AoCInput.readGroupedInputFile(named: Self.testFixture, atIndex: 99).isEmpty)
        #expect(AoCInput.readGroupedInputFile(named: Self.testFixture, atIndex: -1).isEmpty)
    }

    @Test func groupedTextLinesFollowTheInputIndex() {
        let s = StubSolution(day: 99, multipleInputs: true)
        #expect(AoCInput(solution: s, fileName: Self.testFixture, index: 0).textLines == ["alpha", "beta"])
        #expect(AoCInput(solution: s, fileName: Self.testFixture, index: 1).textLines == ["gamma"])
        #expect(AoCInput(solution: s, fileName: Self.testFixture, index: 2).textLines == ["delta", "epsilon", "zeta"])
    }

    @Test func ungroupedTextLinesIgnoreTheIndexAndReturnTheWholeFile() {
        let s = StubSolution(day: 99, multipleInputs: false)
        let input = AoCInput(solution: s, fileName: Self.testFixture, index: 1)
        #expect(input.textLines == ["alpha", "beta", "", "gamma", "", "delta", "epsilon", "zeta"])
    }

    @Test func inputsForAMultiInputSolutionHasOneEntryPerTestGroup() {
        let s = StubSolution(day: 99, multipleInputs: true)
        let inputs = AoCInput.inputsFor(solution: s)
        #expect(inputs.count == 4) // 1 challenge + 3 test groups
        #expect(inputs[0].fileName == Self.challengeFixture)
        #expect(inputs.dropFirst().allSatisfy { $0.fileName == Self.testFixture })
        #expect(inputs.dropFirst().map { $0.index } == [0, 1, 2])
    }

    @Test func everyGroupIsReachableThroughInputsFor() {
        let s = StubSolution(day: 99, multipleInputs: true)
        let testInputs = AoCInput.inputsFor(solution: s).dropFirst()
        #expect(testInputs.allSatisfy { !$0.textLines.isEmpty })
        #expect(testInputs.flatMap { $0.textLines }
                == ["alpha", "beta", "gamma", "delta", "epsilon", "zeta"])
    }
}
