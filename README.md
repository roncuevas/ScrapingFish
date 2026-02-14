# ScrapingFish Swift SDK

A type-safe Swift client for the [ScrapingFish](https://scrapingfish.com) web scraping API. Built with native `URLSession`, async/await, and zero external dependencies.

## Requirements

- Swift 6.0+
- iOS 16+ / macOS 13+

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/roncuevas/ScrapingFish.git", from: "2.0.0")
]
```

Then add `"ScrapingFish"` to your target's dependencies.

## Quick Start

```swift
import ScrapingFish

let client = ScrapingFishClient(apiKey: "your-api-key")

// Scrape a page
let response = try await client.scrape(url: "https://example.com")
print(response.body) // HTML string
```

## Usage

### Basic Scraping

```swift
let client = ScrapingFishClient(apiKey: "your-api-key")

// Simple scrape
let response = try await client.scrape(url: "https://example.com")
print(response.body)
print(response.metadata.statusCode)

// With configuration
let response = try await client.scrape(url: "https://example.com") { req in
    req.renderJS = true
    req.session = "my-session"
    req.totalTimeoutMs = 120_000
}
```

### Decoded JSON Response

```swift
struct Product: Decodable, Sendable {
    let name: String
    let price: Double
}

let response = try await client.scrape(url: "https://shop.com/api", as: [Product].self) { req in
    req.extractRules = ExtractionRules([
        "items": ExtractionRule(selector: ".product", type: .all, output: .text)
    ])
}

for product in response.body {
    print(product.name)
}
```

### JavaScript Rendering

```swift
let response = try await client.scrape(url: "https://spa.com") { req in
    req.renderJS = true
    req.renderJSTimeoutMs = 10_000
    req.browserType = "chrome"
}
```

### JS Scenario (Browser Automation)

Use the `JSScenarioBuilder` for declarative step composition:

```swift
let response = try await client.scrape(url: "https://spa.com") { req in
    req.renderJS = true
    req.jsScenario = JSScenario {
        JSStep.waitFor(selector: "#content", timeout: 5000)
        JSStep.click(selector: "#load-more")
        JSStep.wait(.milliseconds(2000))
    }
}
```

Or build with an array:

```swift
req.jsScenario = JSScenario(steps: [
    .waitFor(selector: "#content", timeout: 5000),
    .click(selector: "#load-more"),
    .wait(.milliseconds(2000)),
])
```

The builder supports conditionals:

```swift
let needsLogin = true

req.jsScenario = JSScenario {
    if needsLogin {
        JSStep.input(selector: "#email", value: "user@example.com")
        JSStep.click(selector: "#login")
    }
    JSStep.waitFor(selector: "#dashboard")
}
```

**Available steps:**

| Step | Description |
|------|-------------|
| `.click(selector:)` | Click an element |
| `.clickIfExists(selector:)` | Click if element exists |
| `.clickAndWaitForNavigation(selector:)` | Click and wait for page navigation |
| `.input(selector:value:)` | Type into an input field |
| `.select(selector:value:)` | Select a dropdown option |
| `.setLocalStorage(key:value:)` | Set a localStorage entry |
| `.scroll(selector:)` | Scroll to element (or page if nil) |
| `.wait(.milliseconds(Int))` | Wait for a fixed duration |
| `.wait(.randomized(min:max:))` | Wait for a random duration |
| `.waitFor(selector:timeout:)` | Wait for an element to appear |
| `.waitForAny([String])` | Wait for any of the selectors |
| `.waitForAnyWithState([WaitForAnyTarget])` | Wait with visible/attached state |
| `.evaluate(String)` | Execute arbitrary JavaScript |

### Extraction Rules

```swift
let response = try await client.scrape(url: "https://example.com") { req in
    req.extractRules = ExtractionRules([
        "title": ExtractionRule(selector: "h1", output: .text),
        "links": ExtractionRule(selector: "a", type: .all, attribute: "href"),
        "table": ExtractionRule(selector: "table", output: .tableJSON),
    ])
}
```

Nested extraction:

```swift
let inner = ExtractionRules([
    "name": ExtractionRule(selector: ".name", output: .text),
    "price": ExtractionRule(selector: ".price", output: .text),
])

req.extractRules = ExtractionRules([
    "products": ExtractionRule(selector: ".product", type: .all, nested: inner)
])
```

**Output types:** `.text`, `.html`, `.tableJSON`, `.tableArray`, or use `attribute:` for element attributes.

### POST / PUT Requests

```swift
let jsonData = Data(#"{"query": "search term"}"#.utf8)

let response = try await client.scrape(url: "https://api.com/search") { req in
    req.method = .post
    req.body = jsonData
    req.bodyContentType = "application/json"
}
```

### Screenshots

```swift
// Default dimensions
let response = try await client.scrape(url: "https://example.com") { req in
    req.renderJS = true
    req.screenshot = .enabled
}

// Custom dimensions
let response = try await client.scrape(url: "https://example.com") { req in
    req.renderJS = true
    req.screenshot = .custom(width: 1920, height: 1080)
    req.screenshotBase64 = true
}
```

### Cookies

```swift
let response = try await client.scrape(url: "https://example.com") { req in
    req.cookies = [
        Cookie(name: "session", value: "abc123", secure: true),
        Cookie(name: "pref", value: "dark", domain: ".example.com"),
    ]
}
```

### Custom Headers

```swift
let response = try await client.scrape(url: "https://example.com") { req in
    req.headers = [
        "Authorization": "Bearer token",
        "Accept-Language": "en-US",
    ]
}
```

### Response Metadata

Every response includes metadata extracted from ScrapingFish headers:

```swift
let response = try await client.scrape(url: "https://example.com")

response.metadata.statusCode          // HTTP status code
response.metadata.resolvedURL         // Final URL after redirects
response.metadata.originalStatusCode  // Original status from target site
response.metadata.cookies             // Cookies set by target site
```

### API Usage

Check your credit usage (free endpoint, no credits consumed):

```swift
let usage = try await client.usage()
print(usage.creditsUsed)
print(usage.creditsRemaining)
print(usage.creditsLimit)
```

### Direct ScrapeRequest

For full control, build a `ScrapeRequest` directly:

```swift
var request = ScrapeRequest()
request.renderJS = true
request.session = "my-session"
request.totalTimeoutMs = 120_000

let response = try await client.scrape(url: "https://example.com", request: request)
```

## All Parameters

| API Parameter | Property | Type |
|---------------|----------|------|
| `render_js` | `renderJS` | `Bool?` |
| `render_js_timeout_ms` | `renderJSTimeoutMs` | `Int?` |
| `browser_type` | `browserType` | `String?` |
| `total_timeout_ms` | `totalTimeoutMs` | `Int?` |
| `trial_timeout_ms` | `trialTimeoutMs` | `Int?` |
| `js_scenario` | `jsScenario` | `JSScenario?` |
| `extract_rules` | `extractRules` | `ExtractionRules?` |
| `intercept_request` | `interceptRequest` | `String?` |
| `headers` | `headers` | `[String: String]?` |
| `cookies` | `cookies` | `[Cookie]?` |
| `session` | `session` | `String?` |
| `screenshot` | `screenshot` | `ScreenshotConfig?` |
| `screenshot_base64` | `screenshotBase64` | `Bool?` |
| `forward_original_status` | `forwardOriginalStatus` | `Bool?` |
| HTTP method | `method` | `HTTPMethod?` |
| Request body | `body` / `bodyContentType` | `Data?` / `String?` |

## Error Handling

```swift
do {
    let response = try await client.scrape(url: "https://example.com")
} catch let error as ScrapingFishError {
    switch error {
    case .httpError(let statusCode, let body):
        print("HTTP \(statusCode): \(body)")
    case .timeout:
        print("Request timed out")
    case .decodingError(let underlying):
        print("Failed to decode: \(underlying)")
    case .networkError(let underlying):
        print("Network error: \(underlying)")
    case .invalidURL(let url):
        print("Invalid URL: \(url)")
    case .unknown(let underlying):
        print("Unknown: \(underlying)")
    }
}
```

## Testing

The client accepts an `HTTPClientProtocol` for dependency injection:

```swift
class MockHTTPClient: HTTPClientProtocol {
    var responseToReturn: HTTPResponse?

    func send(url: URL, method: String, headers: [String: String]?, body: Data?, timeoutInterval: TimeInterval) async throws -> HTTPResponse {
        return responseToReturn!
    }
}

let mock = MockHTTPClient()
mock.responseToReturn = HTTPResponse(data: Data("ok".utf8), statusCode: 200, headers: [:])
let client = ScrapingFishClient(apiKey: "test", httpClient: mock)
```

## License

MIT
