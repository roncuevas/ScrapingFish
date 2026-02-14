import Foundation

public enum ExtractionOutput: String, Sendable {
    case text
    case html
    case tableJSON = "table_json"
    case tableArray = "table_array"
}

public enum ExtractionQuantity: String, Sendable {
    case all
    case first
}

public struct ExtractionRule: Sendable {
    public let selector: String
    public let type: ExtractionQuantity
    public let output: ExtractionOutput?
    public let attribute: String?
    public let nested: ExtractionRules?

    public init(
        selector: String,
        type: ExtractionQuantity = .first,
        output: ExtractionOutput? = nil,
        attribute: String? = nil,
        nested: ExtractionRules? = nil
    ) {
        self.selector = selector
        self.type = type
        self.output = output
        self.attribute = attribute
        self.nested = nested
    }

    func encodeToDictionary() -> [String: Any] {
        var dict: [String: Any] = ["selector": selector]
        if type != .first {
            dict["type"] = type.rawValue
        }
        if let output {
            dict["output"] = output.rawValue
        }
        if let attribute {
            dict["output"] = "@\(attribute)"
        }
        if let nested {
            dict["output"] = nested.encodeToDictionary()
        }
        return dict
    }
}

public struct ExtractionRules: Sendable {
    public let rules: [String: ExtractionRule]

    public init(_ rules: [String: ExtractionRule]) {
        self.rules = rules
    }

    func encodeToDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        for (key, rule) in rules {
            dict[key] = rule.encodeToDictionary()
        }
        return dict
    }

    public func encodeToJSON() -> String {
        let dict = encodeToDictionary()
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: [.sortedKeys]),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }
}
