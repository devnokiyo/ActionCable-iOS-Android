enum DogName: String {
    case chiyo = "chiyo"
    case eru = "eru"
    case otome = "otome"
    
    var capitalized: String {
        return self.rawValue.capitalized
    }
    
    init?(account: String) {
        switch account {
        case DogName.chiyo.rawValue:
            self = .chiyo
        case DogName.eru.rawValue:
            self = .eru
        case DogName.otome.rawValue:
            self = .otome
        default:
            return nil
        }
    }
    
    static var accounts: Array<String> {
        return [DogName.chiyo.rawValue, DogName.eru.rawValue, DogName.otome.rawValue]
    }
}
