import Foundation

public struct UsageResponse: Decodable, Sendable {
    public let creditsUsed: Int
    public let creditsRemaining: Int
    public let creditsLimit: Int

    enum CodingKeys: String, CodingKey {
        case creditsUsed = "credits_used"
        case creditsRemaining = "credits_remaining"
        case creditsLimit = "credits_limit"
    }
}
