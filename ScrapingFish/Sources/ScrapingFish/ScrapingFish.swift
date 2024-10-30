import Foundation

public struct ScrapingFish: Sendable {
    
    private var apiKey: String
    private var timeout: Double
    
    public init(apiKey: String,
                timeout: Double = 60) {
        self.apiKey = apiKey
        self.timeout = timeout
    }
    
    public func debug(url: String,
                       parameters: [ScrapingFishParameter] = []) async throws -> String {
        try await NetworkManager.sendRequest(url: Constants.url,
                                             parameters: parameters.toQueryItems(apiKey: apiKey, url: url),
                                             timeout: timeout)
    }
    
    public func scrape<T: Decodable & Sendable>(url: String,
                                                parameters: [ScrapingFishParameter] = [],
                                                type: T.Type) async throws -> T {
        try await NetworkManager.sendRequest(url: Constants.url,
                                             parameters: parameters.toQueryItems(apiKey: apiKey, url: url),
                                             type: T.self,
                                             timeout: timeout)
    }
}

extension Array<ScrapingFishParameter>: Sendable {
    func toQueryItems(apiKey: String,
                      url: String) -> [String: String] {
        var parameters: [String: String] = ["api_key": apiKey, "url": url]
        for parameter in self {
            parameters[parameter.associatedValue()]  = switch parameter {
            case .sesionID(let value): value
            case .renderJS(let value): value.toString
            case .jsScenario(let value): value.toString
            case .jsScenarioJSON(let value): value
            case .extractRules(let value): value.toString.inBraces
            case .extractRulesJSON(let value): value
            case .headers(let value): value
            }
        }
        return parameters
    }
}

public enum ScrapingFishParameter: Sendable {
    case sesionID(String)
    case renderJS(Bool)
    case jsScenario([JSScenario])
    case jsScenarioJSON(String)
    case extractRules(ExtractionRules)
    case extractRulesJSON(String)
    case headers(String)
    
    func associatedValue() -> String {
        switch self {
        case .sesionID: return "session_id"
        case .renderJS: return "render_js"
        case .jsScenario: return "js_scenario"
        case .jsScenarioJSON: return "js_scenario"
        case .extractRules: return "extract_rules"
        case .extractRulesJSON: return "extract_rules"
        case .headers: return "headers"
        }
    }
}
