import Foundation
@testable import ScrapingFish

final class MockHTTPClient: HTTPClientProtocol, @unchecked Sendable {
    var lastURL: URL?
    var lastMethod: String?
    var lastHeaders: [String: String]?
    var lastBody: Data?
    var lastTimeout: TimeInterval?

    var responseToReturn: HTTPResponse?
    var errorToThrow: Error?

    func send(url: URL, method: String, headers: [String: String]?, body: Data?, timeoutInterval: TimeInterval) async throws -> HTTPResponse {
        lastURL = url
        lastMethod = method
        lastHeaders = headers
        lastBody = body
        lastTimeout = timeoutInterval

        if let error = errorToThrow {
            throw error
        }

        guard let response = responseToReturn else {
            throw ScrapingFishError.unknown(underlying: URLError(.unknown))
        }

        return response
    }
}
