import Foundation

public enum ScrapingFishError: Error, Sendable {
    case invalidURL(String)
    case httpError(statusCode: Int, body: String)
    case decodingError(underlying: Error)
    case networkError(underlying: Error)
    case timeout
    case unknown(underlying: Error)
}

extension ScrapingFishError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .httpError(let statusCode, let body):
            return "HTTP error \(statusCode): \(body)"
        case .decodingError(let underlying):
            return "Decoding error: \(underlying.localizedDescription)"
        case .networkError(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        case .timeout:
            return "Request timed out"
        case .unknown(let underlying):
            return "Unknown error: \(underlying.localizedDescription)"
        }
    }
}
