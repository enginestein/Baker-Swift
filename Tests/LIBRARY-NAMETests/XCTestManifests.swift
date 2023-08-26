import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(LIBRARY-NAMETests.allTests)
    ]
}
#endif
