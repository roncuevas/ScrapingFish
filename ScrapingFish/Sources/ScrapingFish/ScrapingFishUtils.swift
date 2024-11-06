import Foundation

public struct ScrapingFishUtils: Sendable {
    public static func getJsonAsString(from url: URL) throws -> String {
        let jsonData = try Data(contentsOf: url)
        if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
           let jsonDataFormatted = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
           let jsonString = String(data: jsonDataFormatted, encoding: .utf8) {
            return jsonString
        }
        return ""
    }
    
    public static func getUrlsAsStrings(from url: URL) throws -> [String] {
        return try String(contentsOf: url).addHTTPPrefix.components(separatedBy: .newlines)
    }
    
    public static func saveJsonString(_ jsonString: String, to url: URL) throws {
        guard let data = jsonString.data(using: .utf8) else {
            throw NSError(domain: "Error converting string to data", code: -1, userInfo: nil)
        }
        try data.write(to: url)
    }
}
