//
//  EnglishStemmerTests.swift
//  
//
//  Created by Phoenix Trejo on 8/28/20.
//

import XCTest
@testable import SwiftSnowball

final class EnglishStemmerTests: StemmerTestCase<EnglishStemmer> {
    
    override func setUp() {
        stemmer = EnglishStemmer()
    }
    
    override func tearDown() {
        stemmer = nil
    }
    
    func testSmallWords() {
        let stemTests = [
            StemTest(input: "A", output: "a"),
            StemTest(input: "al", output: "al"),
            StemTest(input: " a ", output: "a")
        ]
        
        testStem(with: stemTests)
    }
    
    func testStopWords() {
        let stemTests = [
            StemTest(input: "a", output: "a"),
            StemTest(input: "but", output: "but"),
            StemTest(input: "the", output: "the")
        ]
        
        testStem(with: stemTests)
    }
    
    func testSpecialWords() {
        let stemTests = [
            StemTest(input: "skis", output: "ski"),
            StemTest(input: "idly", output: "idl"),
            StemTest(input: "cannings", output: "canning")
        ]
        
        testStem(with: stemTests)
    }
    
    func testPreprocess() {
        let stemTests = [
            StemTest(input: "arguing", output: "arguing"),
            StemTest(input: "'catty", output: "catty"),
            StemTest(input: "kyle’s", output: "kyle's"),
            StemTest(input: "toy", output: "toY")
        ]
        
        // TODO: Convert to step test
        testStem(with: stemTests)
    }
    
    func testStep0() {
        let stepTests = [
            StepTest(input: "general's", r1Start: 5, r2Start: 9,
                     output: "general", r1Output: 5, r2Output: nil),
            StepTest(input: "general's'", r1Start: 5, r2Start: 10,
                     output: "general", r1Output: 5, r2Output: nil),
            StepTest(input: "spices'", r1Start: 4, r2Start: 7,
                     output: "spices", r1Output: 4, r2Output: nil)
        ]
        
        testStep(stemmer.step0, with: stepTests)
    }
    
    static var allTests = [
        ("testSmallWords", testSmallWords),
        ("testStopWords", testStopWords),
        ("testSpecialWords", testSpecialWords),
        ("testPreprocess", testPreprocess),
        ("testStep0", testStep0),
    ]
}
