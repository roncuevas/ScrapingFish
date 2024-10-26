import XCTest
import ScrapingFish

final class JSScenarioTests: XCTestCase {
    func testScenarioWithWaitAndSimpleType() throws {
        let sut = [JSScenario.wait(.simple(123))].toString
        let expected = "{\"steps\":[{\"wait\":123}]}"
        XCTAssertEqual(sut, expected)
    }
    
    func testWaitAndSimpleType() throws {
        let sut = JSScenario.wait(.simple(123)).toString
        let expected = "{\"wait\":123}"
        XCTAssertEqual(sut, expected)
    }
    
    func testWaitAndRandomizeType() throws {
        let sut = JSScenario.wait(.randomized(.init(minMS: 100, maxMS: 2000))).toString
        let expected = "{\"wait\":{\"random\":{\"min_ms\":100,\"max_ms\":2000}}}"
        XCTAssertEqual(sut, expected)
    }
}
