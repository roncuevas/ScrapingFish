import Foundation

public struct ResponseMetadata: Sendable {
    public let resolvedURL: String?
    public let originalStatusCode: Int?
    public let cookies: String?
    public let statusCode: Int

    init(statusCode: Int, headers: [String: String]) {
        self.statusCode = statusCode
        self.resolvedURL = headers["Resolved-Url"]
        self.cookies = headers["Sf-Cookies"]
        if let statusString = headers["Sf-Original-Status-Code"] {
            self.originalStatusCode = Int(statusString)
        } else {
            self.originalStatusCode = nil
        }
    }
}

public struct ScrapeResponse<T: Sendable>: Sendable {
    public let body: T
    public let metadata: ResponseMetadata
}
