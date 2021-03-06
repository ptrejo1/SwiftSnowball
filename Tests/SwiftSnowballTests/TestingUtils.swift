//
//  TestingUtils.swift
//  
//
//  Created by Phoenix Trejo on 8/29/20.
//

import XCTest
import SwiftCSV
@testable import SwiftSnowball

typealias Step<U: Word> = (_ word: U) -> Void

struct StemTest {
    let input: String
    let stemStopWords: Bool
    let output: String
}

struct StepTest {
    let input: String
    let r1Start: Int?
    let r2Start: Int?
    let output: String
    let r1Output: Int?
    let r2Output: Int?
}

struct R1R2Test {
    let word: String
    let r1: Int?
    let r2: Int?
}

struct VocabTest {
    let input: String
    let output: String
}

class StemmerTestCase: XCTestCase {
    
    func testStem(_ stemmer: Stemmer, with stemTests: [StemTest]) {
        for stemTest in stemTests {
            let word = stemmer.stem(
                stemTest.input,
                stemStopWords: stemTest.stemStopWords
            )
            XCTAssertEqual(word, stemTest.output)
        }
    }
    
    func testStep<U: Word>(_ step: Step<U>, with stepTests: [StepTest]) {
        for stepTest in stepTests {
            var word = U(stepTest.input)
            word.r1 = stepTest.r1Start
            word.r2 = stepTest.r2Start
            step(word)
            
            let str = String(word.characters)
            XCTAssertEqual(str, stepTest.output)
            XCTAssertEqual(word.r1, stepTest.r1Output)
            XCTAssertEqual(word.r2, stepTest.r2Output)
        }
    }
}

class VocabTestCase: XCTestCase {
    
    func testVocab(_ language: Language, csv: String) {
        let csvFile = String(#file.dropLast(18)) + "Vocabs/\(csv)"
        let csv = try! CSV(url: URL(fileURLWithPath: csvFile))
        let stemmer = SnowballStemmer(language: language)
        
        for row in csv.enumeratedRows {
            let stemmed = stemmer.stem(row[0], stemStopWords: true)
            XCTAssertEqual(stemmed, row[1])
        }
    }
}
