struct RoomChannelResponse: Codable {
    let account: String
    let roommate: Array<String>?
    let type: SocketType
    let content: String?
    
    init?(data: Any?) {
        guard let result = JsonUtil.deserialize(data: data, type: RoomChannelResponse.self) else {
            return nil
        }        
        self = result
    }
}
