//
//  AoCSolutionTests.swift
//  AoCLibraryTests
//

import Testing
import Foundation

@Suite("AoCResult")
struct AoCResultTests {

    @Test func descriptionLabelsBothParts() {
        let result = AoCResult(part1: "123", part2: "456")
        #expect(result.description == "Part 1: 123\nPart 2: 456")
        #expect(result.debugDescription == result.description)
    }

    @Test func missingPartsRenderAsEmptyStrings() {
        #expect(AoCResult(part1: nil, part2: nil).description == "Part 1: \nPart 2: ")
        #expect(AoCResult(part1: "1", part2: nil).description == "Part 1: 1\nPart 2: ")
        #expect(AoCResult(part1: nil, part2: "2").description == "Part 1: \nPart 2: 2")
    }

    @Test func partsAreStoredVerbatim() {
        let result = AoCResult(part1: "0", part2: "")
        #expect(result.part1 == "0")
        #expect(result.part2 == "")
    }
}

@Suite("AoCSolution")
struct AoCSolutionTests {

    @Test func defaultsAreDayZeroAndMultipleInputs() {
        let s = AoCSolution()
        #expect(s.day == 0)
        #expect(s.name == "")
        #expect(s.emptyLinesIndicateMultipleInputs == true)
        #expect(s.visualizationEnabled == true)
    }

    @Test func theBaseSolveReturnsEmptyParts() {
        let s = AoCSolution()
        s.day = 7
        s.name = "Base"
        let result = s.solve(AoCInput(solution: s, fileName: "day07_test.txt", index: 0))
        #expect(result.part1 == "")
        #expect(result.part2 == "")
    }

    @Test func theRegistryIsListedNewestDayFirst() {
        let solutions = AoCSolution.solutions
        #expect(!solutions.isEmpty)
        #expect(solutions.map { $0.day } == solutions.map { $0.day }.sorted(by: >))
    }

    @Test func everyRegisteredSolutionIsNamed() {
        for s in AoCSolution.solutions {
            #expect(!s.name.isEmpty, "Day \(s.day) has no name")
        }
    }

    @Test func registeredDaysAreUnique() {
        let days = AoCSolution.solutions.map { $0.day }
        #expect(Set(days).count == days.count)
    }

    @Test func theRegistryBuildsFreshInstancesEachTime() {
        // `solutions` is a computed property, so callers never share state.
        let first = AoCSolution.solutions
        let second = AoCSolution.solutions
        #expect(first.count == second.count)
        for (a, b) in zip(first, second) {
            #expect(a !== b)
            #expect(a.day == b.day)
        }
    }

    @Test func subclassesCanOverrideTheirMetadata() {
        let stub = StubSolution(day: 12, multipleInputs: false)
        #expect(stub.day == 12)
        #expect(stub.name == "Stub")
        #expect(stub.emptyLinesIndicateMultipleInputs == false)
    }
}

@Suite("Day00")
struct Day00Tests {

    @Test func metadataMatchesTheTemplateSolution() {
        let day = Day00()
        #expect(day.day == 0)
        #expect(day.name == "Test Solution")
        #expect(day.emptyLinesIndicateMultipleInputs == true)
    }

    @Test func solveReturnsTheTemplateAnswers() {
        let day = Day00()
        let result = day.solve(AoCInput(solution: day, fileName: "day00_test.txt", index: 0))
        #expect(result.part1 == "hello")
        #expect(result.part2 == "sync")
    }

    @Test func theRegistryIncludesDay00() {
        #expect(AoCSolution.solutions.contains { $0 is Day00 })
    }
}
