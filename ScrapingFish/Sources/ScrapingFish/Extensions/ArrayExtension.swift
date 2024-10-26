extension Array where Element == String {
    var commaSeparated: String {
        return joined(separator: ",")
    }
}

extension Array<JSScenario> {
    var toString: String {
        let steps = map { $0.toString }
        "steps".inQuotes.colon +
    }
}
