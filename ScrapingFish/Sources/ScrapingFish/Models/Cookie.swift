import Foundation

public struct Cookie: Codable, Sendable {
    public let name: String
    public let value: String
    public let domain: String?
    public let path: String?
    public let secure: Bool?
    public let httpOnly: Bool?

    public init(
        name: String,
        value: String,
        domain: String? = nil,
        path: String? = nil,
        secure: Bool? = nil,
        httpOnly: Bool? = nil
    ) {
        self.name = name
        self.value = value
        self.domain = domain
        self.path = path
        self.secure = secure
        self.httpOnly = httpOnly
    }

    enum CodingKeys: String, CodingKey {
        case name, value, domain, path, secure
        case httpOnly = "httpOnly"
    }
}
