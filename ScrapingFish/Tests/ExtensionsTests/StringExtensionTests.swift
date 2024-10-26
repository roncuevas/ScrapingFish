import XCTest
import ScrapingFish

final class StringExtensionTests: XCTestCase {
    func testInBraces() throws {
        let sut = "Hello, world!"
        XCTAssertEqual(sut.inBraces, "{Hello, world!}")
    }
    
    func testInBrackets() throws {
        let sut = "Hello, world!"
        XCTAssertEqual(sut.inBrackets, "[Hello, world!]")
    }
    
    func testInQuotes() throws {
        let sut = "Hello, world!"
        XCTAssertEqual(sut.inQuotes, "\"Hello, world!\"")
    }
    
    func testColon() throws {
        let sut = "Hello"
        XCTAssertEqual(sut.colon, "Hello:")
    }
    
    func testComma() throws {
        let sut = "Hello"
        XCTAssertEqual(sut.comma, "Hello,")
    }
    
    func testKeyValue() throws {
        let sut = String.keyValue("hello".inBraces, "world".inBrackets)
        XCTAssertEqual(sut, "{hello}:[world]")
    }
}
