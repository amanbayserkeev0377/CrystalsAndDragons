enum ItemType: Equatable {
    case key
    case chest
    case torchlight
    case food(restoreAmount: Int)
    case sword
    case gold(coins: Int)
}

class Item {
    let type: ItemType
    let name: String
    
    init(type: ItemType, name: String) {
        self.type = type
        self.name = name
    }
    
    var displayName: String {
        switch type {
        case .gold(let coins):
            return "gold (\(coins) coins)"
        default:
            return name
        }
    }
}
