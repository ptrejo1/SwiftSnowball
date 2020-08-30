//
//  File.swift
//  
//
//  Created by Phoenix Trejo on 8/29/20.
//

import XCTest
@testable import SwiftSnowball

typealias Step<U: Word> = (_ word: U) -> Void

struct StemTest {
    let input: String
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

class StemmerTestCase<T: Stemmer>: XCTestCase {
    
    var stemmer: T!
    
    func testStem(with stemTests: [StemTest]) {
        for stemTest in stemTests {
            let word = stemmer.stem(stemTest.input, ignoreStopWords: false)
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
