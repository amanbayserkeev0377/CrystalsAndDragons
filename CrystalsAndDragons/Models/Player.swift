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
}
