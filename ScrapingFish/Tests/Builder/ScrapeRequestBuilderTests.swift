import Testing
import Foundation
@testable import ScrapingFish

@Suite("ScrapeRequest Configuration Closure")
struct ScrapeRequestConfigTests {
    @Test("Configures request with multiple parameters")
    func multipleParams() {
        let request = ScrapeRequest { req in
            req.renderJS = true
            req.session = "my-session"
            req.totalTimeoutMs = 120000
        }
        #expect(request.renderJS == true)
        #expect(request.session == "my-session")
        #expect(request.totalTimeoutMs == 120000)
    }

    @Test("Configures request with conditional parameters")
    func conditionalParams() {
        let useJS = true
        let request = ScrapeRequest { req in
            if useJS {
                req.renderJS = true
            }
            req.session = "s1"
        }
        #expect(request.renderJS == true)
        #expect(request.session == "s1")
    }

    @Test("Configures request with false conditional")
    func falseConditional() {
        let useJS = false
        let request = ScrapeRequest { req in
            if useJS {
                req.renderJS = true
            }
            req.session = "s1"
        }
        #expect(request.renderJS == nil)
        #expect(request.session == "s1")
    }

    @Test("Configures request with screenshot config")
    func screenshotConfig() {
        let request = ScrapeRequest { req in
            req.screenshot = .custom(width: 1920, height: 1080)
            req.screenshotBase64 = true
        }
        if case .custom(let w, let h) = request.screenshot {
            #expect(w == 1920)
            #expect(h == 1080)
        } else {
            Issue.record("Expected custom screenshot config")
        }
        #expect(request.screenshotBase64 == true)
    }

    @Test("Configures request with POST method and body")
    func postWithBody() {
        let jsonData = Data("{\"key\":\"value\"}".utf8)
        let request = ScrapeRequest { req in
            req.method = .post
            req.body = jsonData
            req.bodyContentType = "application/json"
        }
        #expect(request.method == .post)
        #expect(request.body == jsonData)
        #expect(request.bodyContentType == "application/json")
    }

    @Test("Configures request with cookies")
    func withCookies() {
        let request = ScrapeRequest { req in
            req.cookies = [Cookie(name: "s", value: "v")]
        }
        #expect(request.cookies?.count == 1)
        #expect(request.cookies?.first?.name == "s")
    }

    @Test("Configures request with headers")
    func withHeaders() {
        let request = ScrapeRequest { req in
            req.headers = ["Authorization": "Bearer token"]
        }
        #expect(request.headers?["Authorization"] == "Bearer token")
    }

    @Test("Configures request with jsScenario")
    func withJSScenario() {
        let request = ScrapeRequest { req in
            req.renderJS = true
            req.jsScenario = JSScenario(steps: [.click(selector: "#btn")])
        }
        #expect(request.renderJS == true)
        #expect(request.jsScenario != nil)
    }

    @Test("Configures request with extract rules")
    func withExtractRules() {
        let request = ScrapeRequest { req in
            req.extractRules = ExtractionRules(["title": ExtractionRule(selector: "h1", output: .text)])
        }
        #expect(request.extractRules != nil)
    }
}
