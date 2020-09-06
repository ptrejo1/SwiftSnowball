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
    
    func testStep1c() {
        let stepTests = [
            StepTest(input: "cry", r1Start: 3, r2Start: 3,
                     output: "cri", r1Output: 3, r2Output: 3),
            StepTest(input: "say", r1Start: 3, r2Start: 3,
                     output: "say", r1Output: 3, r2Output: 3),
            StepTest(input: "by", r1Start: 2, r2Start: 2,
                     output: "by", r1Output: 2, r2Output: 2),
            StepTest(input: "xexby", r1Start: 2, r2Start: 5,
                     output: "xexbi", r1Output: 2, r2Output: 5)
        ]
        
        testStep(stemmer.step1c, with: stepTests)
    }
    
    func testStep2() {
        let stepTests = [
            StepTest(input: "fluentli", r1Start: 5, r2Start: nil,
                     output: "fluentli", r1Output: 5, r2Output: nil),
            StepTest(input: "xxxtional", r1Start: 3, r2Start: 5,
                     output: "xxxtion", r1Output: 3, r2Output: 5),
            StepTest(input: "xxxtional", r1Start: 4, r2Start: 5,
                     output: "xxxtional", r1Output: 4, r2Output: 5),
            StepTest(input: "xxxcli", r1Start: 3, r2Start: 6,
                     output: "xxxc", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxcli", r1Start: 3, r2Start: 6,
                     output: "xxxc", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxli", r1Start: 3, r2Start: nil,
                     output: "xxxxli", r1Output: 3, r2Output: nil),
            StepTest(input: "xxlogi", r1Start: 2, r2Start: nil,
                     output: "xxlog", r1Output: 2, r2Output: nil),
            StepTest(input: "xxxogi", r1Start: 2, r2Start: nil,
                     output: "xxxogi", r1Output: 2, r2Output: nil),
            StepTest(input: "xxxxenci", r1Start: 3, r2Start: 7,
                     output: "xxxxence", r1Output: 3, r2Output: 7),
            StepTest(input: "xxxxanci", r1Start: 3, r2Start: 7,
                     output: "xxxxance", r1Output: 3, r2Output: 7),
            StepTest(input: "xxxxabli", r1Start: 3, r2Start: 7,
                     output: "xxxxable", r1Output: 3, r2Output: 7),
            StepTest(input: "xxxxentli", r1Start: 3, r2Start: 8,
                     output: "xxxxent", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxizer", r1Start: 3, r2Start: 7,
                     output: "xxxxize", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxization", r1Start: 3, r2Start: 10,
                     output: "xxxxize", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxational", r1Start: 3, r2Start: 10,
                     output: "xxxxate", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxation", r1Start: 3, r2Start: 8,
                     output: "xxxxate", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxator", r1Start: 3, r2Start: 7,
                     output: "xxxxate", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxalism", r1Start: 3, r2Start: 8,
                     output: "xxxxal", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxaliti", r1Start: 3, r2Start: 8,
                     output: "xxxxal", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxalli", r1Start: 3, r2Start: 7,
                     output: "xxxxal", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxfulness", r1Start: 3, r2Start: 10,
                     output: "xxxxful", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxousli", r1Start: 3, r2Start: 8,
                     output: "xxxxous", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxousness", r1Start: 3, r2Start: 10,
                     output: "xxxxous", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxiveness", r1Start: 3, r2Start: 10,
                     output: "xxxxive", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxiviti", r1Start: 3, r2Start: 8,
                     output: "xxxxive", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxbiliti", r1Start: 3, r2Start: 9,
                     output: "xxxxble", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxbli", r1Start: 3, r2Start: 6,
                     output: "xxxxble", r1Output: 3, r2Output: 6),
            StepTest(input: "xxxxfulli", r1Start: 3, r2Start: 8,
                     output: "xxxxful", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxlessli", r1Start: 3, r2Start: 8,
                     output: "xxxxless", r1Output: 3, r2Output: nil),
            StepTest(input: "xxxxenci", r1Start: nil, r2Start: nil,
                     output: "xxxxenci", r1Output: nil, r2Output: nil),
            StepTest(input: "xxxxanci", r1Start: nil, r2Start: nil,
                     output: "xxxxanci", r1Output: nil, r2Output: nil),
            StepTest(input: "xxxxabli", r1Start: nil, r2Start: nil,
                     output: "xxxxabli", r1Output: nil, r2Output: nil),
            StepTest(input: "xxxxentli", r1Start: nil, r2Start: nil,
                     output: "xxxxentli", r1Output: nil, r2Output: nil),
            StepTest(input: "xxxxizer", r1Start: nil, r2Start: nil,
                     output: "xxxxizer", r1Output: nil, r2Output: nil),
            StepTest(input: "xxxxization", r1Start: nil, r2Start: nil,
                     output: "xxxxization", r1Output: nil, r2Output: nil),
            StepTest(input: "xxxxational", r1Start: nil, r2Start: nil,
                     output: "xxxxational", r1Output: nil, r2Output: nil),
            StepTest(input: "xxxxation", r1Start: nil, r2Start: nil,
                     output: "xxxxation", r1Output: nil, r2Output: nil),
            StepTest(input: "xxxxator", r1Start: nil, r2Start: nil,
                     output: "xxxxator", r1Output: nil, r2Output: nil),
        ]
        
        testStep(stemmer.step2, with: stepTests)
    }
    
    static var allTests = [
        ("testSmallWords", testSmallWords),
        ("testStopWords", testStopWords),
        ("testSpecialWords", testSpecialWords),
        ("testPreprocess", testPreprocess),
        ("testStep0", testStep0),
        ("testStep1a", testStep1a),
        ("testStep1b", testStep1b),
        ("testStep1c", testStep1c),
        ("testStep2", testStep2),
    ]
}
