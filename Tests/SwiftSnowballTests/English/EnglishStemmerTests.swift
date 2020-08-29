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
        let wordTests = [
            WordTest(input: "A", output: "a"),
            WordTest(input: "al", output: "al"),
            WordTest(input: " a ", output: "a")
        ]
        
        testStem(with: wordTests)
    }
    
    func testStopWords() {
        let wordTests = [
            WordTest(input: "a", output: "a"),
            WordTest(input: "but", output: "but"),
            WordTest(input: "the", output: "the")
        ]
        
        testStem(with: wordTests)
    }
    
    func testSpecialWords() {
        let wordTests = [
            WordTest(input: "skis", output: "ski"),
            WordTest(input: "idly", output: "idl"),
            WordTest(input: "cannings", output: "canning")
        ]
        
        testStem(with: wordTests)
    }
    
    func testPreprocess() {
        let wordTests = [
            WordTest(input: "arguing", output: "arguing"),
            WordTest(input: "'catty", output: "catty"),
            WordTest(input: "kyle’s", output: "kyle's"),
            WordTest(input: "toy", output: "toY")
        ]
        
        testStem(with: wordTests)
    }
    
    static var allTests = [
        ("testSmallWords", testSmallWords),
        ("testStopWords", testStopWords),
        ("testSpecialWords", testSpecialWords),
        ("testPreprocess", testPreprocess),
    ]
}
