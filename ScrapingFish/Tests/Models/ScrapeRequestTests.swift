import Testing
import Foundation
@testable import ScrapingFish

@Suite("ScrapeRequest Query Items")
struct ScrapeRequestTests {
    private func queryDict(from request: ScrapeRequest, apiKey: String = "k", url: String = "https://x.com") -> [String: String] {
        let items = request.toQueryItems(apiKey: apiKey, url: url)
        return Dictionary(uniqueKeysWithValues: items.map { ($0.name, $0.value ?? "") })
    }

    @Test("Generates api_key and url query items")
    func basicQueryItems() {
        let dict = queryDict(from: ScrapeRequest(), apiKey: "test-key", url: "https://example.com")
        #expect(dict["api_key"] == "test-key")
        #expect(dict["url"] == "https://example.com")
    }

    @Test("Includes render_js parameter")
    func renderJS() {
        var request = ScrapeRequest()
        request.renderJS = true
        let dict = queryDict(from: request)
        #expect(dict["render_js"] == "true")
    }

    @Test("Includes session parameter")
    func session() {
        var request = ScrapeRequest()
        request.session = "my-session"
        let dict = queryDict(from: request)
        #expect(dict["session"] == "my-session")
    }

    @Test("Includes timeout parameters")
    func timeouts() {
        var request = ScrapeRequest()
        request.totalTimeoutMs = 120000
        request.trialTimeoutMs = 30000
        request.renderJSTimeoutMs = 10000
        let dict = queryDict(from: request)
        #expect(dict["total_timeout_ms"] == "120000")
        #expect(dict["trial_timeout_ms"] == "30000")
        #expect(dict["render_js_timeout_ms"] == "10000")
    }

    @Test("Includes browser_type parameter")
    func browserType() {
        var request = ScrapeRequest()
        request.browserType = "chrome"
        let dict = queryDict(from: request)
        #expect(dict["browser_type"] == "chrome")
    }

    @Test("Includes screenshot parameters")
    func screenshot() {
        var request = ScrapeRequest()
        request.screenshot = .custom(width: 1920, height: 1080)
        let dict = queryDict(from: request)
        #expect(dict["screenshot"] == "true")
        #expect(dict["screenshot_width"] == "1920")
        #expect(dict["screenshot_height"] == "1080")
    }

    @Test("Includes screenshot enabled only")
    func screenshotEnabled() {
        var request = ScrapeRequest()
        request.screenshot = .enabled
        let dict = queryDict(from: request)
        #expect(dict["screenshot"] == "true")
        #expect(dict["screenshot_width"] == nil)
    }

    @Test("Includes method parameter for POST")
    func methodPost() {
        var request = ScrapeRequest()
        request.method = .post
        let dict = queryDict(from: request)
        #expect(dict["method"] == "POST")
    }

    @Test("Omits method parameter for GET")
    func methodGetOmitted() {
        var request = ScrapeRequest()
        request.method = .get
        let dict = queryDict(from: request)
        #expect(dict["method"] == nil)
    }

    @Test("Includes cookies parameter")
    func cookies() throws {
        var request = ScrapeRequest()
        request.cookies = [Cookie(name: "s", value: "v", secure: true)]
        let dict = queryDict(from: request)
        let json = try #require(dict["cookies"])
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [[String: Any]]
        #expect(parsed.count == 1)
        #expect(parsed[0]["name"] as? String == "s")
    }

    @Test("Includes headers parameter")
    func headers() throws {
        var request = ScrapeRequest()
        request.headers = ["Authorization": "Bearer token"]
        let dict = queryDict(from: request)
        let json = try #require(dict["headers"])
        let parsed = try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: String]
        #expect(parsed["Authorization"] == "Bearer token")
    }

    @Test("Includes js_scenario parameter")
    func jsScenario() {
        var request = ScrapeRequest()
        request.jsScenario = JSScenario(steps: [.wait(.milliseconds(1000))])
        let dict = queryDict(from: request)
        let expected = "{\"steps\":[{\"wait\":1000}]}"
        #expect(dict["js_scenario"] == expected)
    }

    @Test("Includes extract_rules parameter")
    func extractRules() {
        var request = ScrapeRequest()
        request.extractRules = ExtractionRules(["title": ExtractionRule(selector: "h1", output: .text)])
        let dict = queryDict(from: request)
        #expect(dict["extract_rules"] != nil)
    }

    @Test("Includes intercept_request parameter")
    func interceptRequest() {
        var request = ScrapeRequest()
        request.interceptRequest = "block_images"
        let dict = queryDict(from: request)
        #expect(dict["intercept_request"] == "block_images")
    }

    @Test("Includes forward_original_status parameter")
    func forwardOriginalStatus() {
        var request = ScrapeRequest()
        request.forwardOriginalStatus = true
        let dict = queryDict(from: request)
        #expect(dict["forward_original_status"] == "true")
    }

    @Test("Includes screenshot_base64 parameter")
    func screenshotBase64() {
        var request = ScrapeRequest()
        request.screenshotBase64 = true
        let dict = queryDict(from: request)
        #expect(dict["screenshot_base64"] == "true")
    }

    @Test("Includes body content_type parameter")
    func bodyContentType() {
        var request = ScrapeRequest()
        request.method = .post
        request.body = Data("test".utf8)
        request.bodyContentType = "application/json"
        let dict = queryDict(from: request)
        #expect(dict["content_type"] == "application/json")
    }
}
