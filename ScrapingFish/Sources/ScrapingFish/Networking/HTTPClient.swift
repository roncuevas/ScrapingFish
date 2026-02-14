import Foundation

public struct HTTPResponse: Sendable {
    public let data: Data
    public let statusCode: Int
    public let headers: [String: String]

    public init(data: Data, statusCode: Int, headers: [String: String]) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
    }
}

public protocol HTTPClientProtocol: Sendable {
    func send(url: URL, method: String, headers: [String: String]?, body: Data?, timeoutInterval: TimeInterval) async throws -> HTTPResponse
}

public struct URLSessionHTTPClient: HTTPClientProtocol, Sendable {
    public init() {}

    public func send(url: URL, method: String, headers: [String: String]?, body: Data?, timeoutInterval: TimeInterval) async throws -> HTTPResponse {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = timeoutInterval
        request.httpBody = body

        if let headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let error as URLError where error.code == .timedOut {
            throw ScrapingFishError.timeout
        } catch {
            throw ScrapingFishError.networkError(underlying: error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ScrapingFishError.unknown(underlying: URLError(.badServerResponse))
        }

        var responseHeaders: [String: String] = [:]
        for (key, value) in httpResponse.allHeaderFields {
            if let keyStr = key as? String, let valStr = value as? String {
                responseHeaders[keyStr] = valStr
            }
        }

        return HTTPResponse(
            data: data,
            statusCode: httpResponse.statusCode,
            headers: responseHeaders
        )
    }
}
