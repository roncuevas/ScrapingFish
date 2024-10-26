import XCTest
import ScrapingFish

final class ArrayExtensionTests: XCTestCase {
    func testCommaSeparated() throws {
        let sut: [String] = ["hello", "world", "control"]
        XCTAssertEqual(sut.commaSeparated, "hello,world,control")
    }
}
