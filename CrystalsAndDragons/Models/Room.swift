enum Direction: CaseIterable {
    case north, south, east, west
    
    var opposite: Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
    
    var displayName: String {
        switch self {
        case .north: return "N"
        case .south: return "S"
        case .east: return "E"
        case .west: return "W"
        }
    }
}

class Room {
    let x: Int
    let y: Int
    var doors: Set<Direction>
    var items: [Item]
    var isDark: Bool
    var isLit: Bool
    var monster: Monster?
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.doors = []
        self.items = []
        self.isDark = false
        self.isLit = false
    }
}
