//
//  StandardWordTestsTests.swift
//
//
//  Created by Phoenix Trejo on 8/26/20.
//

import XCTest
@testable import SwiftSnowball

final class StandardWordTests: XCTestCase {
    
    func testStandardR() {
        let standardWord = StandardWord("crepuscular")
        let r1 = standardWord.standardR(
            start: 0, vowels: EnglishUtils.vowels)
        XCTAssertEqual(r1, 4)
        
        let r2 = standardWord.standardR(
            start: r1!, vowels: EnglishUtils.vowels)
        XCTAssertEqual(r2, 6)
        
        let notFound = standardWord.standardR(
            start: 8, vowels: EnglishUtils.vowels)
        XCTAssertNil(notFound)
    }

    static var allTests = [
        ("testStandardR", testStandardR),
    ]
}
