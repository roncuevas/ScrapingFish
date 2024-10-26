public extension Array where Element == String {
    var commaSeparated: String {
        return joined(separator: ",")
    }
}

public extension Array<JSScenario> {
    var toString: String {
        let steps = map { $0.toString }
        return "steps".inQuotes
    }
}
