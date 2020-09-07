//
//  EnglishVocabTests.swift
//  
//
//  Created by Phoenix Trejo on 9/6/20.
//

import XCTest
@testable import SwiftSnowball


final class EnglishVocabTests: VocabTestCase {
    
    func testEnglishVocab() {
        testVocab(.english, csv: "english_vocab.csv")
    }
    
    static var allTests = [
        ("testVocab", testEnglishVocab),
    ]
}
