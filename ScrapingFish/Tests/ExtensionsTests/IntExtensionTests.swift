import XCTest
import ScrapingFish

final class IntExtensionTests: XCTestCase {
    func testToString() throws {
        let integers: [Int] = [1, 2, 3, 4, 5]
        let sut: [String] = integers.map { $0.toString }
        XCTAssertEqual(sut, ["1", "2", "3", "4", "5"])
    }
}
