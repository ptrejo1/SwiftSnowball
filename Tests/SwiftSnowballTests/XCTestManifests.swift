import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(StandardWordTests.allTests),
        testCase(EnglishWordTests.allTests)
    ]
}
#endif
