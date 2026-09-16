//
//  AoCStringTests.swift
//  AoCLibraryTests
//

import Testing
import Foundation

@Suite("String: integer subscript")
struct StringSubscriptTests {

    @Test func readsCharacterByOffset() {
        let s = "hello"
        #expect(s[0] == "h")
        #expect(s[1] == "e")
        #expect(s[4] == "o")
    }

    @Test func offsetsCountCharactersNotBytes() {
        let s = "héllo"
        #expect(s[1] == "é")
        #expect(s[4] == "o")
    }

    @Test func writesCharacterByOffset() {
        var s = "hello"
        s[0] = "H"
        #expect(s == "Hello")
    }

    @Test func writeInTheMiddleAndAtTheEnd() {
        var s = "hello"
        s[2] = "L"
        s[4] = "!"
        #expect(s == "heLl!")
    }

    @Test func writeDoesNotChangeLength() {
        var s = "abcde"
        for i in 0..<s.count {
            s[i] = "x"
        }
        #expect(s == "xxxxx")
    }

    @Test func subscriptRoundTripsEveryCharacter() {
        let s = "abcdef"
        #expect((0..<s.count).map { s[$0] } == Array(s))
    }
}

@Suite("String.indexesOf")
struct StringIndexesOfTests {

    @Test func findsEveryNonOverlappingOccurrence() {
        #expect("abcabc".indexesOf(string: "abc") == [0, 3])
        #expect("xxabcxx".indexesOf(string: "abc") == [2])
    }

    @Test func findsOverlappingOccurrences() {
        #expect("aaaa".indexesOf(string: "aa") == [0, 1, 2])
    }

    @Test func findsSingleCharacters() {
        #expect("mississippi".indexesOf(string: "s") == [2, 3, 5, 6])
        #expect("mississippi".indexesOf(string: "ss") == [2, 5])
    }

    @Test func returnsEmptyWhenNotFound() {
        #expect("abcdef".indexesOf(string: "xyz").isEmpty)
    }

    @Test func returnsEmptyWhenNeedleIsLongerThanHaystack() {
        #expect("ab".indexesOf(string: "abc").isEmpty)
    }

    @Test func returnsEmptyForAnEmptyNeedle() {
        // The `!range.isEmpty` guard stops an empty match from looping forever.
        #expect("abc".indexesOf(string: "").isEmpty)
    }

    @Test func returnsEmptyForAnEmptyHaystack() {
        #expect("".indexesOf(string: "a").isEmpty)
    }

    @Test func matchAtTheVeryEnd() {
        #expect("abcxyz".indexesOf(string: "xyz") == [3])
    }

    @Test func matchOfTheWholeString() {
        #expect("abc".indexesOf(string: "abc") == [0])
    }

    @Test func searchIsCaseSensitive() {
        #expect("aAaA".indexesOf(string: "A") == [1, 3])
    }

    @Test func indexesAreCharacterOffsetsUsableWithTheSubscript() {
        let haystack = "ábcábc"
        let indexes = haystack.indexesOf(string: "bc")
        #expect(indexes == [1, 4])
        for i in indexes {
            #expect(haystack[i] == "b")
        }
    }
}
