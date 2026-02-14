import Foundation

@resultBuilder
public struct JSScenarioBuilder {
    public static func buildExpression(_ expression: JSStep) -> [JSStep] {
        [expression]
    }

    public static func buildBlock(_ components: [JSStep]...) -> [JSStep] {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [JSStep]?) -> [JSStep] {
        component ?? []
    }

    public static func buildEither(first component: [JSStep]) -> [JSStep] {
        component
    }

    public static func buildEither(second component: [JSStep]) -> [JSStep] {
        component
    }

    public static func buildArray(_ components: [[JSStep]]) -> [JSStep] {
        components.flatMap { $0 }
    }
}
