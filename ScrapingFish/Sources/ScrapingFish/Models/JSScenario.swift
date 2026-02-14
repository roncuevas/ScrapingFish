import Foundation

public enum WaitDuration: Sendable {
    case milliseconds(Int)
    case randomized(min: Int, max: Int)
}

public enum WaitState: String, Sendable {
    case visible
    case attached
}

public struct WaitForAnyTarget: Sendable {
    public let selector: String
    public let state: WaitState

    public init(selector: String, state: WaitState) {
        self.selector = selector
        self.state = state
    }
}

public enum JSStep: Sendable {
    case click(selector: String)
    case clickIfExists(selector: String)
    case clickAndWaitForNavigation(selector: String)
    case input(selector: String, value: String)
    case select(selector: String, value: String)
    case setLocalStorage(key: String, value: String)
    case scroll(selector: String? = nil)
    case wait(WaitDuration)
    case waitFor(selector: String, timeout: Int? = nil)
    case waitForAny([String])
    case waitForAnyWithState([WaitForAnyTarget])
    case evaluate(String)
}

public struct JSScenario: Sendable {
    public let steps: [JSStep]

    public init(steps: [JSStep]) {
        self.steps = steps
    }

    public init(@JSScenarioBuilder builder: () -> [JSStep]) {
        self.steps = builder()
    }

    public func encodeToJSON() -> String {
        let stepsJSON = steps.map { encodeStep($0) }
        let stepsArray = "[\(stepsJSON.joined(separator: ","))]"
        return "{\"steps\":\(stepsArray)}"
    }

    private func encodeStep(_ step: JSStep) -> String {
        switch step {
        case .click(let selector):
            return "{\"click\":\(encodeString(selector))}"
        case .clickIfExists(let selector):
            return "{\"click_if_exists\":\(encodeString(selector))}"
        case .clickAndWaitForNavigation(let selector):
            return "{\"click_and_wait_for_navigation\":\(encodeString(selector))}"
        case .input(let selector, let value):
            return "{\"input\":\(encodeString(selector)),\"value\":\(encodeString(value))}"
        case .select(let selector, let value):
            return "{\"select\":\(encodeString(selector)),\"value\":\(encodeString(value))}"
        case .setLocalStorage(let key, let value):
            return "{\"set_local_storage\":{\(encodeString(key)):\(encodeString(value))}}"
        case .scroll(let selector):
            if let selector {
                return "{\"scroll\":\(encodeString(selector))}"
            } else {
                return "{\"scroll\":true}"
            }
        case .wait(let duration):
            return encodeWait(duration)
        case .waitFor(let selector, let timeout):
            if let timeout {
                return "{\"wait_for\":\(encodeString(selector)),\"timeout_ms\":\(timeout)}"
            } else {
                return "{\"wait_for\":\(encodeString(selector))}"
            }
        case .waitForAny(let selectors):
            let array = selectors.map { encodeString($0) }.joined(separator: ",")
            return "{\"wait_for_any\":[\(array)]}"
        case .waitForAnyWithState(let targets):
            let array = targets.map { target in
                "{\"selector\":\(encodeString(target.selector)),\"state\":\(encodeString(target.state.rawValue))}"
            }.joined(separator: ",")
            return "{\"wait_for_any\":[\(array)]}"
        case .evaluate(let js):
            return "{\"evaluate\":\(encodeString(js))}"
        }
    }

    private func encodeWait(_ duration: WaitDuration) -> String {
        switch duration {
        case .milliseconds(let ms):
            return "{\"wait\":\(ms)}"
        case .randomized(let min, let max):
            return "{\"wait\":{\"random\":{\"min_ms\":\(min),\"max_ms\":\(max)}}}"
        }
    }

    private func encodeString(_ value: String) -> String {
        let escaped = value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
            .replacingOccurrences(of: "\t", with: "\\t")
        return "\"\(escaped)\""
    }
}
