class ConsoleView {
    
    // MARK: - Output
    
    func showRoomDescription(_ room: Room, health: Int) {
        let directions = room.doors.map { $0.displayName }.sorted().joined(separator: ", ")
        let items = room.items.map { $0.displayName }.joined(separator: ", ")
        let itemsText = items.isEmpty ? "none" : items
        
        print("Your are in room[\(room.x),\(room.y)]. There are \(room.doors.count) doors: \(directions). Items in the room: \(itemsText)")
        print("Health: \(health)")
    }
    
    func showDarkRoom() {
        print("Can't see anything in this dark place!")
    }
    
    func showMonster(_ monster: Monster) {
        print("There is an evil \(monster.name) in the room!")
    }
    
    func showMessage(_ message: String) {
        print(message)
    }
    
    // MARK: - Input
    
    func getInput() -> String {
        print("> ", terminator: "")
        return readLine() ?? ""
    }
}
