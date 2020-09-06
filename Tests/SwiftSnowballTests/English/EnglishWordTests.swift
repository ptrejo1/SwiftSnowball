//
//  EnglishWordTests.swift
//  
//
//  Created by Phoenix Trejo on 8/26/20.
//

import XCTest
@testable import SwiftSnowball

fileprivate struct RemoveTest {
    let input: String
    let r1Start: Int?
    let r2Start: Int?
    let n: Int
    let output: String
    let r1Output: Int?
    let r2Output: Int?
}

fileprivate struct SuffixTest {
    let word: String
    let suffixes: [String]
    let suffix: String?
}

fileprivate struct SuffixReplaceTest {
    let input: String
    let r1Start: Int?
    let r2Start: Int?
    let suffix: String
    let replace: String
    let output: String
    let r1Output: Int?
    let r2Output: Int?
}

fileprivate struct ShortWordTest {
    let word: String
    let isShort: Bool
}

fileprivate struct ShortSyllableTest {
    let word: String
    let position: Int
    let isShort: Bool
}

final class EnglishWordTests: XCTestCase {
    
    func testNormalizeApostrophes() {
        let englishWord = EnglishWord("\u{2019}x\u{2018}x\u{201B}")
        englishWord.normalizeApostrophes()
        XCTAssertEqual(englishWord.description, "'x'x'")
    }
    
    func testTrimLeadingApostrophes() {
        let englishWord = EnglishWord("'foo")
        englishWord.trimLeadingApostrophes()
        XCTAssertEqual(englishWord.description, "foo")
    }
    
    func testCapitalizeYs() {
        let englishWord = EnglishWord("ysdcsdeysdfsysdfsdiyoyyyxyxayxey")
        englishWord.capitalizeYs()
        XCTAssertEqual(englishWord.description, "YsdcsdeYsdfsysdfsdiYoYyYxyxaYxeY")
    }
    
    func testFindR1R2() {
        let r1r2Tests = [
            R1R2Test(word: "crepuscular", r1: 4, r2: 6),
            R1R2Test(word: "beautiful", r1: 5, r2: 7),
            R1R2Test(word: "beauty", r1: 5, r2: nil),
            R1R2Test(word: "eucharist", r1: 3, r2: 6),
            R1R2Test(word: "animadversion", r1: 2, r2: 4),
            R1R2Test(word: "mistresses", r1: 3, r2: 7),
            R1R2Test(word: "sprinkled", r1: 5, r2: nil),
            R1R2Test(word: "communism", r1: 6, r2: 8),
            R1R2Test(word: "arsenal", r1: 5, r2: nil),
            R1R2Test(word: "generalities", r1: 5, r2: 7),
            R1R2Test(word: "embed", r1: 2, r2: nil)
        ]
        
        for test in r1r2Tests {
            let englishWord = EnglishWord(test.word)
            englishWord.findR1R2()
            XCTAssertEqual(englishWord.r1, test.r1)
            XCTAssertEqual(englishWord.r2, test.r2)
        }
    }
    
    func testDropLast() {
        let removeTests = [
            RemoveTest(input: "aabbccddee", r1Start: 8, r2Start: 9, n: 0,
                       output: "aabbccddee", r1Output: 8, r2Output: 9),
            RemoveTest(input: "aabbccddee", r1Start: 8, r2Start: 9, n: 5,
                       output: "aabbc", r1Output: nil, r2Output: nil),
            RemoveTest(input: "aabbccddee", r1Start: 8, r2Start: 9, n: 1,
                       output: "aabbccdde", r1Output: 8, r2Output: nil)
        ]
        
        for removeTest in removeTests {
            let word = EnglishWord(removeTest.input)
            word.r1 = removeTest.r1Start
            word.r2 = removeTest.r2Start
            word.dropLast(removeTest.n)
            
            XCTAssertEqual(word.description, removeTest.output)
            XCTAssertEqual(word.r1, removeTest.r1Output)
            XCTAssertEqual(word.r2, removeTest.r2Output)
        }
    }
    
    func testFirstSuffix() {
        let suffixTests = [
            SuffixTest(word: "firehose", suffixes: ["x", "fi"], suffix: nil),
            SuffixTest(word: "firehose", suffixes: ["x", "hose", "fi"], suffix: "hose"),
            SuffixTest(word: "firehose", suffixes: ["x", "se"], suffix: "se"),
            SuffixTest(word: "firehose", suffixes: ["fire", "xfirehose"], suffix: nil)
        ]
        
        for suffixTest in suffixTests {
            let word = EnglishWord(suffixTest.word)
            let suffix = word.firstSuffix(in: suffixTest.suffixes)
            XCTAssertEqual(suffix, suffixTest.suffix)
        }
    }
    
    func testReplaceSuffix() {
        let suffixReplaceTests = [
            SuffixReplaceTest(input: "accliviti", r1Start: 2, r2Start: 6,
                              suffix: "iviti", replace: "ive",
                              output: "acclive", r1Output: 2, r2Output: 6),
            SuffixReplaceTest(input: "skating", r1Start: 4, r2Start: 6,
                              suffix: "ing", replace: "e",
                              output: "skate", r1Output: 4, r2Output: nil),
            SuffixReplaceTest(input: "convirtiéndo", r1Start: 3, r2Start: 6,
                              suffix: "iéndo", replace: "iendo",
                              output: "convirtiendo", r1Output: 3, r2Output: 6)
        ]
        
        for suffixReplaceTest in suffixReplaceTests {
            let word = EnglishWord(suffixReplaceTest.input)
            word.r1 = suffixReplaceTest.r1Start
            word.r2 = suffixReplaceTest.r2Start
            word.replaceSuffix(suffixReplaceTest.suffix,
                               with: suffixReplaceTest.replace)
            
            XCTAssertEqual(word.description, suffixReplaceTest.output)
            XCTAssertEqual(word.r1, suffixReplaceTest.r1Output)
            XCTAssertEqual(word.r2, suffixReplaceTest.r2Output)
        }
    }
    
    func testIsShortWord() {
        let shortWordTests = [
            ShortWordTest(word: "bed", isShort: true),
            ShortWordTest(word: "shed", isShort: true),
            ShortWordTest(word: "shred", isShort: true),
            ShortWordTest(word: "bead", isShort: false),
            ShortWordTest(word: "embed", isShort: false),
            ShortWordTest(word: "beds", isShort: false)
        ]
        
        for shortWordTest in shortWordTests {
            let word = EnglishWord(shortWordTest.word)
            word.findR1R2()
            let isShort = word.isShortWord()
            XCTAssertEqual(isShort, shortWordTest.isShort)
        }
    }
    
    func testEndsInShortSyllable() {
        let shortSyllableTests = [
            ShortSyllableTest(word: "absolute", position: 7, isShort: true),
            ShortSyllableTest(word: "ape", position: 2, isShort: true),
            ShortSyllableTest(word: "rap", position: 3, isShort: true),
            ShortSyllableTest(word: "trap", position: 4, isShort: true),
            ShortSyllableTest(word: "entrap", position: 6, isShort: true),
            ShortSyllableTest(word: "uproot", position: 6, isShort: false),
            ShortSyllableTest(word: "bestow", position: 6, isShort: false),
            ShortSyllableTest(word: "disturb", position: 7, isShort: false)
        ]
        
        for shortSyllableTest in shortSyllableTests {
            let word = EnglishWord(shortSyllableTest.word)
            let isShort = word.endsInShortSyllable(at: shortSyllableTest.position)
            XCTAssertEqual(isShort, shortSyllableTest.isShort)
        }
    }
    
    static var allTests = [
        ("testNormalizeApostrophes", testNormalizeApostrophes),
        ("testTrimLeadingApostrophes", testTrimLeadingApostrophes),
        ("testCapitalizeYs", testCapitalizeYs),
        ("testFindR1R2", testFindR1R2),
        ("testDropLast", testDropLast),
        ("testFirstSuffix", testFirstSuffix),
        ("testReplaceSuffix", testReplaceSuffix),
        ("testIsShortWord", testIsShortWord),
        ("testEndsInShortSyllable", testEndsInShortSyllable),
    ]
}
