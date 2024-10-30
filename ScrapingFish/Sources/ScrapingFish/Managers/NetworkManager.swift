import Alamofire
import Foundation

class NetworkManager {
    
    private init() {}
    
    static func sendRequest<T: Decodable & Sendable>(url: String,
                                                     parameters: [String: String],
                                                     type: T.Type,
                                                     timeout: Double) async throws -> T {
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = timeout
        let dataTask = manager.request(url,
                                  method: .get,
                                  parameters: parameters).serializingDecodable(T.self)
        return try await dataTask.value
    }

    static func sendRequest(url: String,
                            parameters: [String: String],
                            timeout: Double) async throws -> String {
        let dataTask = AF.request(url,
                                  method: .get,
                                  parameters: parameters).serializingString()
        return try await dataTask.value
    }
}
