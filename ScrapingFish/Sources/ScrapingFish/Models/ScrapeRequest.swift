import Foundation

public struct ScrapeRequest: Sendable {
    public var renderJS: Bool?
    public var renderJSTimeoutMs: Int?
    public var browserType: String?
    public var totalTimeoutMs: Int?
    public var trialTimeoutMs: Int?
    public var jsScenario: JSScenario?
    public var extractRules: ExtractionRules?
    public var interceptRequest: String?
    public var headers: [String: String]?
    public var cookies: [Cookie]?
    public var session: String?
    public var screenshot: ScreenshotConfig?
    public var screenshotBase64: Bool?
    public var forwardOriginalStatus: Bool?
    public var method: HTTPMethod?
    public var body: Data?
    public var bodyContentType: String?

    public init() {}

    public init(configure: ScrapeRequestConfigurator) {
        configure(&self)
    }

    public func toQueryItems(apiKey: String, url: String) -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "url", value: url),
        ]

        if let renderJS {
            items.append(URLQueryItem(name: "render_js", value: renderJS ? "true" : "false"))
        }
        if let renderJSTimeoutMs {
            items.append(URLQueryItem(name: "render_js_timeout_ms", value: String(renderJSTimeoutMs)))
        }
        if let browserType {
            items.append(URLQueryItem(name: "browser_type", value: browserType))
        }
        if let totalTimeoutMs {
            items.append(URLQueryItem(name: "total_timeout_ms", value: String(totalTimeoutMs)))
        }
        if let trialTimeoutMs {
            items.append(URLQueryItem(name: "trial_timeout_ms", value: String(trialTimeoutMs)))
        }
        if let jsScenario {
            items.append(URLQueryItem(name: "js_scenario", value: jsScenario.encodeToJSON()))
        }
        if let extractRules {
            items.append(URLQueryItem(name: "extract_rules", value: extractRules.encodeToJSON()))
        }
        if let interceptRequest {
            items.append(URLQueryItem(name: "intercept_request", value: interceptRequest))
        }
        if let headers {
            if let data = try? JSONSerialization.data(withJSONObject: headers, options: [.sortedKeys]),
               let json = String(data: data, encoding: .utf8) {
                items.append(URLQueryItem(name: "headers", value: json))
            }
        }
        if let cookies {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(cookies),
               let json = String(data: data, encoding: .utf8) {
                items.append(URLQueryItem(name: "cookies", value: json))
            }
        }
        if let session {
            items.append(URLQueryItem(name: "session", value: session))
        }
        if let screenshot {
            switch screenshot {
            case .enabled:
                items.append(URLQueryItem(name: "screenshot", value: "true"))
            case .custom(let width, let height):
                items.append(URLQueryItem(name: "screenshot", value: "true"))
                items.append(URLQueryItem(name: "screenshot_width", value: String(width)))
                items.append(URLQueryItem(name: "screenshot_height", value: String(height)))
            }
        }
        if let screenshotBase64 {
            items.append(URLQueryItem(name: "screenshot_base64", value: screenshotBase64 ? "true" : "false"))
        }
        if let forwardOriginalStatus {
            items.append(URLQueryItem(name: "forward_original_status", value: forwardOriginalStatus ? "true" : "false"))
        }
        if let method, method != .get {
            items.append(URLQueryItem(name: "method", value: method.rawValue))
        }
        if let bodyContentType {
            items.append(URLQueryItem(name: "content_type", value: bodyContentType))
        }

        return items
    }
}
