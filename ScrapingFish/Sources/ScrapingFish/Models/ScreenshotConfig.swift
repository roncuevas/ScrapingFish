import Foundation

public enum ScreenshotConfig: Sendable {
    case enabled
    case custom(width: Int, height: Int)
}
