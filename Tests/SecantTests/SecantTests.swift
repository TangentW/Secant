import XCTest
@testable import Secant

final class SecantTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Secant().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
