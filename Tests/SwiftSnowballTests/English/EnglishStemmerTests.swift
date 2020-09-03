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
        let stepTests = [
            StepTest(input: "arguing", r1Start: nil, r2Start: nil,
                     output: "arguing", r1Output: 2, r2Output: 6),
            StepTest(input: "'catty", r1Start: nil, r2Start: nil,
                     output: "catty", r1Output: 3, r2Output: nil),
            StepTest(input: "kyle’s", r1Start: nil, r2Start: nil,
                     output: "kyle's", r1Output: 3, r2Output: 5),
            StepTest(input: "toy", r1Start: nil, r2Start: nil,
                     output: "toY", r1Output: nil, r2Output: nil),
        ]
        
        testStep(stemmer.preprocess, with: stepTests)
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
    
    func testStep1a() {
        let stepTests = [
            StepTest(input: "ties", r1Start: 0, r2Start: 0,
                     output: "tie", r1Output: 0, r2Output: 0),
            StepTest(input: "cries", r1Start: 0, r2Start: 0,
                     output: "cri", r1Output: 0, r2Output: 0),
            StepTest(input: "mistresses", r1Start: 3, r2Start: 7,
                     output: "mistress", r1Output: 3, r2Output: 7),
            StepTest(input: "ied", r1Start: 3, r2Start: 3,
                     output: "ie", r1Output: nil, r2Output: nil),
        ]
        
        testStep(stemmer.step1a, with: stepTests)
    }
    
    func testStep1b() {
        let stepTests = [
            StepTest(input: "exxeedly", r1Start: 1, r2Start: 8,
                     output: "exxee", r1Output: 1, r2Output: nil),
            StepTest(input: "exxeed", r1Start: 1, r2Start: 7,
                     output: "exxee", r1Output: 1, r2Output: nil),
            StepTest(input: "luxuriated", r1Start: 3, r2Start: 5,
                     output: "luxuriate", r1Output: 3, r2Output: 5),
            StepTest(input: "luxuribled", r1Start: 3, r2Start: 5,
                     output: "luxurible", r1Output: 3, r2Output: 5),
            StepTest(input: "luxuriized", r1Start: 3, r2Start: 5,
                     output: "luxuriize", r1Output: 3, r2Output: 5),
            StepTest(input: "luxuriedly", r1Start: 3, r2Start: 5,
                     output: "luxuri", r1Output: 3, r2Output: 5),
            StepTest(input: "vetted", r1Start: 3, r2Start: 6,
                     output: "vet", r1Output: nil, r2Output: nil),
            StepTest(input: "hopping", r1Start: 3, r2Start: 7,
                     output: "hop", r1Output: nil, r2Output: nil),
            StepTest(input: "breed", r1Start: nil, r2Start: nil,
                     output: "breed", r1Output: nil, r2Output: nil),
            StepTest(input: "skating", r1Start: 4, r2Start: 6,
                     output: "skate", r1Output: 4, r2Output: nil)
        ]
        
        testStep(stemmer.step1b, with: stepTests)
    }
    
    static var allTests = [
        ("testSmallWords", testSmallWords),
        ("testStopWords", testStopWords),
        ("testSpecialWords", testSpecialWords),
        ("testPreprocess", testPreprocess),
        ("testStep0", testStep0),
        ("testStep1a", testStep1a),
        ("testStep1b", testStep1b),
    ]
}
