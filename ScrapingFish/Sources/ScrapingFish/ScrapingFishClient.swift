import Foundation

public struct ScrapingFishClient: Sendable {
    private static let baseURL = "https://api.scrapingfish.com/api/v1/"
    private static let usageURL = "https://api.scrapingfish.com/api/usage/"

    private let apiKey: String
    private let timeoutInterval: TimeInterval
    private let httpClient: HTTPClientProtocol

    public init(apiKey: String, timeoutInterval: TimeInterval = 60, httpClient: HTTPClientProtocol = URLSessionHTTPClient()) {
        self.apiKey = apiKey
        self.timeoutInterval = timeoutInterval
        self.httpClient = httpClient
    }

    // MARK: - Scrape (raw HTML)

    public func scrape(
        url: String,
        configure: ScrapeRequestConfigurator = { _ in }
    ) async throws -> ScrapeResponse<String> {
        let request = ScrapeRequest(configure: configure)
        return try await scrape(url: url, request: request)
    }

    public func scrape(url: String, request: ScrapeRequest) async throws -> ScrapeResponse<String> {
        let response = try await performRequest(url: url, request: request)
        let body = String(data: response.data, encoding: .utf8) ?? ""
        return ScrapeResponse(
            body: body,
            metadata: ResponseMetadata(statusCode: response.statusCode, headers: response.headers)
        )
    }

    // MARK: - Scrape (decoded)

    public func scrape<T: Decodable & Sendable>(
        url: String,
        as type: T.Type,
        configure: ScrapeRequestConfigurator = { _ in }
    ) async throws -> ScrapeResponse<T> {
        let request = ScrapeRequest(configure: configure)
        return try await scrape(url: url, as: type, request: request)
    }

    public func scrape<T: Decodable & Sendable>(url: String, as type: T.Type, request: ScrapeRequest) async throws -> ScrapeResponse<T> {
        let response = try await performRequest(url: url, request: request)
        let metadata = ResponseMetadata(statusCode: response.statusCode, headers: response.headers)
        do {
            let decoded = try JSONDecoder().decode(T.self, from: response.data)
            return ScrapeResponse(body: decoded, metadata: metadata)
        } catch {
            throw ScrapingFishError.decodingError(underlying: error)
        }
    }

    // MARK: - Usage

    public func usage() async throws -> UsageResponse {
        guard var components = URLComponents(string: Self.usageURL) else {
            throw ScrapingFishError.invalidURL(Self.usageURL)
        }
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]

        guard let url = components.url else {
            throw ScrapingFishError.invalidURL(Self.usageURL)
        }

        let response = try await httpClient.send(
            url: url,
            method: "GET",
            headers: nil,
            body: nil,
            timeoutInterval: timeoutInterval
        )

        guard (200...299).contains(response.statusCode) else {
            let body = String(data: response.data, encoding: .utf8) ?? ""
            throw ScrapingFishError.httpError(statusCode: response.statusCode, body: body)
        }

        do {
            return try JSONDecoder().decode(UsageResponse.self, from: response.data)
        } catch {
            throw ScrapingFishError.decodingError(underlying: error)
        }
    }

    // MARK: - Private

    private func performRequest(url: String, request: ScrapeRequest) async throws -> HTTPResponse {
        guard var components = URLComponents(string: Self.baseURL) else {
            throw ScrapingFishError.invalidURL(Self.baseURL)
        }

        components.queryItems = request.toQueryItems(apiKey: apiKey, url: url)

        guard let requestURL = components.url else {
            throw ScrapingFishError.invalidURL(url)
        }

        let httpMethod = (request.method ?? .get).rawValue

        var requestHeaders: [String: String]? = nil
        if let contentType = request.bodyContentType {
            requestHeaders = ["Content-Type": contentType]
        }

        let response = try await httpClient.send(
            url: requestURL,
            method: httpMethod,
            headers: requestHeaders,
            body: request.body,
            timeoutInterval: timeoutInterval
        )

        guard (200...299).contains(response.statusCode) else {
            let body = String(data: response.data, encoding: .utf8) ?? ""
            throw ScrapingFishError.httpError(statusCode: response.statusCode, body: body)
        }

        return response
    }
}
