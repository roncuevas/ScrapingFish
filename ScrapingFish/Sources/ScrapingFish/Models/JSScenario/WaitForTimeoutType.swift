public enum WaitForTimeoutType: Sendable {
    case simple(Int)
    case randomized(WaitForTimeoutObject)
    
    var toString: String {
        switch self {
        case .simple(let time): String(time)
        case .randomized(let object): object.toString
        }
    }
}

public struct WaitForTimeoutObject: Sendable {
    let minMS: Int
    let maxMS: Int
    
    var toString: String {
        let minMSString = "min_ms".inQuotes.colon + minMS.toString
        let maxMSString = "max_ms".inQuotes.colon + maxMS.toString
        let objectString = (minMSString.comma + maxMSString).inBraces
        return "random".inQuotes.colon + objectString
    }
}
