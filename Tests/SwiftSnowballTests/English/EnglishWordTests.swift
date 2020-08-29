//
//  EnglishWordTests.swift
//  
//
//  Created by Phoenix Trejo on 8/26/20.
//

import XCTest
@testable import SwiftSnowball

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
    
    static var allTests = [
        ("testNormalizeApostrophes", testNormalizeApostrophes),
        ("testTrimLeadingApostrophes", testTrimLeadingApostrophes),
        ("testCapitalizeYs", testCapitalizeYs),
        ("testFindR1R2", testFindR1R2),
    ]
}
