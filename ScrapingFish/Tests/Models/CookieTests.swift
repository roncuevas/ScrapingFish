import Testing
import Foundation
@testable import ScrapingFish

@Suite("Cookie Codable")
struct CookieTests {
    @Test("Encodes cookie to JSON")
    func encodeCookie() throws {
        let cookie = Cookie(name: "session", value: "abc123", secure: true)
        let data = try JSONEncoder().encode(cookie)
        let dict = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        #expect(dict["name"] as? String == "session")
        #expect(dict["value"] as? String == "abc123")
        #expect(dict["secure"] as? Bool == true)
        #expect(dict["domain"] == nil)
    }

    @Test("Decodes cookie from JSON")
    func decodeCookie() throws {
        let json = #"{"name":"token","value":"xyz","domain":".example.com","path":"/","secure":false,"httpOnly":true}"#
        let cookie = try JSONDecoder().decode(Cookie.self, from: Data(json.utf8))
        #expect(cookie.name == "token")
        #expect(cookie.value == "xyz")
        #expect(cookie.domain == ".example.com")
        #expect(cookie.path == "/")
        #expect(cookie.secure == false)
        #expect(cookie.httpOnly == true)
    }

    @Test("Round-trips cookie encoding/decoding")
    func roundTrip() throws {
        let original = Cookie(name: "test", value: "val", domain: ".test.com", path: "/api", secure: true, httpOnly: false)
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Cookie.self, from: data)
        #expect(decoded.name == original.name)
        #expect(decoded.value == original.value)
        #expect(decoded.domain == original.domain)
        #expect(decoded.path == original.path)
        #expect(decoded.secure == original.secure)
        #expect(decoded.httpOnly == original.httpOnly)
    }
}
