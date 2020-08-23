import XCTest
@testable import SwiftSnowball

final class SwiftSnowballTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftSnowball().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
