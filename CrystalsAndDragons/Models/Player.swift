class Player {
    var currentRoom: Room
    var previousRoom: Room?
    var inventory: [Item]
    var health: Int
    var gold: Int
    
    init(startRoom: Room, health: Int) {
        self.currentRoom = startRoom
        self.previousRoom = nil
        self.inventory = []
        self.health = health
        self.gold = 0
    }
    
    func hasItem(named name: String) -> Bool {
        return inventory.contains { $0.name == name }
    }
    
    func pickUp(item: Item) {
        inventory.append(item)
    }
    
    func drop(item: Item) {
        inventory.removeAll { $0.name == item.name }
    }
    
    var hasSword: Bool {
        return hasItem(named: "sword")
    }
}
