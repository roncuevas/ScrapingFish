import Testing
import Foundation
@testable import ScrapingFish

@Suite("ScrapingFishClient")
struct ScrapingFishClientTests {
    private func makeMock(data: Data = Data(), statusCode: Int = 200, headers: [String: String] = [:]) -> (ScrapingFishClient, MockHTTPClient) {
        let mock = MockHTTPClient()
        mock.responseToReturn = HTTPResponse(data: data, statusCode: statusCode, headers: headers)
        let client = ScrapingFishClient(apiKey: "test-key", httpClient: mock)
        return (client, mock)
    }

    // MARK: - Request Building

    @Test("Sends correct URL with api_key and url query params")
    func sendsCorrectURL() async throws {
        let (client, mock) = makeMock(data: Data("<html></html>".utf8))
        _ = try await client.scrape(url: "https://example.com")
        let url = mock.lastURL!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let queryDict = Dictionary(uniqueKeysWithValues: components.queryItems!.map { ($0.name, $0.value!) })
        #expect(queryDict["api_key"] == "test-key")
        #expect(queryDict["url"] == "https://example.com")
        #expect(components.host == "api.scrapingfish.com")
    }

    @Test("Sends GET method by default")
    func defaultGetMethod() async throws {
        let (client, mock) = makeMock(data: Data("<html></html>".utf8))
        _ = try await client.scrape(url: "https://example.com")
        #expect(mock.lastMethod == "GET")
    }

    @Test("Sends POST method when specified")
    func postMethod() async throws {
        let (client, mock) = makeMock(data: Data("ok".utf8))
        let bodyData = Data("test".utf8)
        _ = try await client.scrape(url: "https://example.com") { req in
            req.method = .post
            req.body = bodyData
            req.bodyContentType = "text/plain"
        }
        #expect(mock.lastMethod == "POST")
        #expect(mock.lastBody == bodyData)
        #expect(mock.lastHeaders?["Content-Type"] == "text/plain")
    }

    @Test("Includes render_js in query when using configurator")
    func renderJSInQuery() async throws {
        let (client, mock) = makeMock(data: Data("html".utf8))
        _ = try await client.scrape(url: "https://example.com") { req in
            req.renderJS = true
        }
        let components = URLComponents(url: mock.lastURL!, resolvingAgainstBaseURL: false)!
        let queryDict = Dictionary(uniqueKeysWithValues: components.queryItems!.map { ($0.name, $0.value!) })
        #expect(queryDict["render_js"] == "true")
    }

    // MARK: - Response Parsing

    @Test("Parses raw HTML response")
    func rawHTMLResponse() async throws {
        let html = "<html><body>Hello</body></html>"
        let (client, _) = makeMock(data: Data(html.utf8))
        let response = try await client.scrape(url: "https://example.com")
        #expect(response.body == html)
    }

    @Test("Parses response metadata from headers")
    func responseMetadata() async throws {
        let headers: [String: String] = [
            "Resolved-Url": "https://resolved.example.com",
            "Sf-Original-Status-Code": "301",
            "Sf-Cookies": "session=abc",
        ]
        let (client, _) = makeMock(data: Data("ok".utf8), headers: headers)
        let response = try await client.scrape(url: "https://example.com")
        #expect(response.metadata.resolvedURL == "https://resolved.example.com")
        #expect(response.metadata.originalStatusCode == 301)
        #expect(response.metadata.cookies == "session=abc")
    }

    @Test("Decodes typed JSON response")
    func decodedResponse() async throws {
        let json = "{\"name\":\"test\",\"value\":42}"
        let (client, _) = makeMock(data: Data(json.utf8))
        let response = try await client.scrape(url: "https://example.com", as: TestModel.self)
        #expect(response.body.name == "test")
        #expect(response.body.value == 42)
    }

    // MARK: - Error Handling

    @Test("Throws httpError for non-2xx status")
    func httpError() async throws {
        let (client, _) = makeMock(data: Data("forbidden".utf8), statusCode: 403)
        await #expect(throws: ScrapingFishError.self) {
            _ = try await client.scrape(url: "https://example.com")
        }
    }

    @Test("Throws decodingError for invalid JSON")
    func decodingError() async throws {
        let (client, _) = makeMock(data: Data("not json".utf8))
        await #expect(throws: ScrapingFishError.self) {
            _ = try await client.scrape(url: "https://example.com", as: TestModel.self)
        }
    }

    @Test("Throws networkError when mock throws")
    func networkError() async throws {
        let mock = MockHTTPClient()
        mock.errorToThrow = ScrapingFishError.timeout
        let client = ScrapingFishClient(apiKey: "k", httpClient: mock)
        await #expect(throws: ScrapingFishError.self) {
            _ = try await client.scrape(url: "https://example.com")
        }
    }

    // MARK: - Usage

    @Test("Calls usage endpoint")
    func usageEndpoint() async throws {
        let json = "{\"credits_used\":100,\"credits_remaining\":900,\"credits_limit\":1000}"
        let (client, mock) = makeMock(data: Data(json.utf8))
        let usage = try await client.usage()
        #expect(usage.creditsUsed == 100)
        #expect(usage.creditsRemaining == 900)
        #expect(usage.creditsLimit == 1000)
        #expect(mock.lastURL?.absoluteString.contains("usage") == true)
    }

    @Test("Usage throws httpError for non-2xx")
    func usageHttpError() async throws {
        let (client, _) = makeMock(data: Data("error".utf8), statusCode: 401)
        await #expect(throws: ScrapingFishError.self) {
            _ = try await client.usage()
        }
    }

    // MARK: - Timeout

    @Test("Passes timeout interval to HTTP client")
    func passesTimeout() async throws {
        let mock = MockHTTPClient()
        mock.responseToReturn = HTTPResponse(data: Data("ok".utf8), statusCode: 200, headers: [:])
        let client = ScrapingFishClient(apiKey: "k", timeoutInterval: 30, httpClient: mock)
        _ = try await client.scrape(url: "https://example.com")
        #expect(mock.lastTimeout == 30)
    }
}

private struct TestModel: Decodable, Sendable {
    let name: String
    let value: Int
}
