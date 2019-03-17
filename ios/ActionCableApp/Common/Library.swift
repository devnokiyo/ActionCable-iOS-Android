import Foundation
class JsonUtil {
    static func deserialize<T>(data: Any?, type: T.Type) -> T? where T : Decodable {
        guard let dic = data as? NSDictionary,
            let jsonData = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 2)),
            let jsonString = String(data: jsonData, encoding: .utf8),
            let response = try? JSONDecoder().decode(type, from: jsonString.data(using: .utf8)!) else {
                return nil
        }        
        return response
    }
}
