public enum WaitForAnyType: Sendable {
    case simple([String])
    case specificState([WaitForAnyObject])
    
    var toString: String {
        switch self {
        case .simple(let content):
            return content.commaSeparated.inBrackets
        case .specificState(let content):
            return content.map { $0.toString }.commaSeparated.inBrackets
        }
    }
}

public struct WaitForAnyObject: Sendable {
    var selector: String
    var state: StateType
    
    var toString: String {
        let selectorString = "selector".inQuotes.colon + selector.inQuotes
        let stateString = "state".inQuotes.colon + state.rawValue.inQuotes
        return (selectorString.comma + stateString).inBraces
    }
}

public enum StateType: String, Sendable {
    case visible
    case attached
}
