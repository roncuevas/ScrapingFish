public enum JSScenario: Sendable {
    case click
    case clickIfExists
    case clickAndWaitForNavigation
    case input
    case select
    case setLocalStorage
    case scroll
    case wait(WaitForTimeoutType)
    case waitFor
    case waitForAny(WaitForAnyType)
    case evaluate
    
    var rawValue: String {
        switch self {
        case .click: "click"
        case .clickIfExists: "click_if_exists"
        case .clickAndWaitForNavigation: "click_and_wait_for_navigation"
        case .input: "input"
        case .select: "select"
        case .setLocalStorage: "set_local_storage"
        case .scroll: "scroll"
        case .wait: "wait"
        case .waitFor: "wait_for"
        case .waitForAny: "wait_for_any"
        case .evaluate: "evaluate"
        }
    }
    
    var toString: String {
        switch self {
        case .click: ""
        case .clickIfExists: ""
        case .clickAndWaitForNavigation: ""
        case .input: ""
        case .select: ""
        case .setLocalStorage: ""
        case .scroll: ""
        case .wait(let type): type.toString
        case .waitFor: ""
        case .waitForAny(let type): type.toString
        case .evaluate: ""
        }
    }
}
