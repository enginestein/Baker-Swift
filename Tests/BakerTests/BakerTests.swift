@testable import Baker
import XCTest

final class BakerTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(Baker().test(), "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample)
    ]
}
