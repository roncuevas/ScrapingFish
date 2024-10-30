public typealias ExtractionRules = [ExtractionRule]

public extension ExtractionRules {
    var toString: String {
        self.map { $0.toString }.commaSeparated
    }
}

public final class ExtractionRule: Sendable {
    let name: String
    let type: ExtractionType
    let selectors: [SelectorType]?
    let output: ExtractionOutputType?
    
    public init(name: String = "output",
                type: ExtractionType = .first,
                selectors: [SelectorType]? = nil,
                output: ExtractionOutputType? = nil) {
        self.name = name
        self.type = type
        self.selectors = selectors
        self.output = output
    }
    
    public var toString: String {
        let name: String = name.inQuotes.colon
        var data: String = ""
        if type != .first {
            data = data + type.toString
        }
        if let selectors {
            let selectorsSeparated: String = selectors.map { $0.toString }.commaSeparated
            data = data.isEmpty ? selectorsSeparated : data.comma + selectorsSeparated
        }
        if let output {
            data = data.isEmpty ? output.toString : data.comma + output.toString
        }
        return name + data.inBraces
    }
}

public struct SelectorType: Sendable {
    let name: String
    let value: String
    
    public init(name: String? = nil,
                _ value: String) {
        self.name = name ?? "selector"
        self.value = value
    }
    
    public var toString: String {
        name.inQuotes.colon + value.inQuotes
    }
}

public enum ExtractionOutputType: Sendable {
    case text
    case html
    case tableJSON
    case tableArray
    case attribute(String)
    case href
    case nested([ExtractionRule])
    
    public var toString: String {
        let output = "output".inQuotes.colon
        switch self {
        case .text: 
            return output + "text".inQuotes
        case .html:
            return output + "html".inQuotes
        case .tableJSON:
            return output + "table_json".inQuotes
        case .tableArray:
            return output + "table_array".inQuotes
        case .attribute(let value):
            return output + "@\(value)".inQuotes
        case .href:
            return output + "@href".inQuotes
        case .nested(let value):
            return value.toString
        }
    }
}

public enum ExtractionType: String, Sendable {
    case all
    case first
    
    public var toString: String {
        return "type".inQuotes.colon + rawValue.inQuotes
    }
}
