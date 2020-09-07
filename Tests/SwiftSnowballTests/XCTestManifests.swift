import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(StandardWordTests.allTests),
        testCase(EnglishStemmerTests.allTests),
        testCase(EnglishWordTests.allTests),
        testCase(EnglishVocabTests.allTests)
    ]
}
#endif
