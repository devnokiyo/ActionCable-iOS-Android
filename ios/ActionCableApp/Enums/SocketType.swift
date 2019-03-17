enum SocketType: String, Codable {
    case roomIn = "in"
    case roomOut = "out"
    case mumbling = "mumbling"
    case bark = "bark"
    
    init?(type: String) {
        switch type {
        case SocketType.roomIn.rawValue:
            self = .roomIn
        case SocketType.roomOut.rawValue:
            self = .roomOut
        case SocketType.mumbling.rawValue:
            self = .mumbling
        case SocketType.bark.rawValue:
            self = .bark
        default:
            return nil
        }
    }
}
