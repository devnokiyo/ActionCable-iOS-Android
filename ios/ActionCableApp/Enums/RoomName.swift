enum RoomName: String {
    case tuna = "tuna"
    case egg = "egg"
    case salmonRoe = "salmon_roe"
    
    static var names: Array<String> {
        return [RoomName.tuna.rawValue, RoomName.egg.rawValue, RoomName.salmonRoe.rawValue]
    }
}

