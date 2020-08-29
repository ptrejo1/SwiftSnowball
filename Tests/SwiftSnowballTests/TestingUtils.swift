//
//  File.swift
//  
//
//  Created by Phoenix Trejo on 8/29/20.
//

import XCTest
@testable import SwiftSnowball

typealias Step<U: Word> = (_ word: U) -> Void

struct WordTest {
    let input: String
    let output: String
}

struct R1R2Test {
    let word: String
    let r1: Int?
    let r2: Int?
}

class StemmerTestCase<T: Stemmer>: XCTestCase {
    
    var stemmer: T!
    
    func testStem(with wordTests: [WordTest]) {
        for wordTest in wordTests {
            let word = stemmer.stem(wordTest.input, ignoreStopWords: false)
            XCTAssertEqual(word, wordTest.output)
        }
    }
    
    func testStep<U: Word>(_ step: Step<U>, with wordTests: [WordTest]) {
        for wordTest in wordTests {
            let word = U(wordTest.input)
            step(word)
            
            let str = String(word.characters)
            XCTAssertEqual(str, wordTest.output)
        }
    }
}
