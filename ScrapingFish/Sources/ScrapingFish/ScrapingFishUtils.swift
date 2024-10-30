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
}
