class ConsoleView {
    
    // MARK: - Output
    
    func showRoomDescription(_ room: Room, health: Int) {
        let directions = room.doors.map { $0.displayName }.sorted().joined(separator: ", ")
        let items = room.items.map { $0.displayName }.joined(separator: ", ")
        let itemsText = items.isEmpty ? "none" : items
        
        print("\(ANSIColor.green)You are in the room [\(room.x),\(room.y)].\(ANSIColor.reset) There are \(room.doors.count) doors: \(ANSIColor.cyan)\(directions)\(ANSIColor.reset). Items in the room: \(ANSIColor.yellow)\(itemsText)\(ANSIColor.reset).")
        print("\(ANSIColor.red)Health: \(health)\(ANSIColor.reset)")
    }

    func showDarkRoom() {
        print("\(ANSIColor.white)Can't see anything in this dark place! (you can still move: N, S, W, E)\(ANSIColor.reset)")
    }

    func showMonster(_ monster: Monster) {
        print("\(ANSIColor.red)There is an evil \(monster.name) in the room!\(ANSIColor.reset)")
    }

    func showMessage(_ message: String) {
        print(message)
    }

    func showWin() {
        print("\(ANSIColor.yellow)You opened the chest and found the Holy Grail! YOU WIN! 🏆\(ANSIColor.reset)")
    }

    func showGameOver() {
        print("\(ANSIColor.red)You died of hunger in the dark dungeon. GAME OVER. 💀\(ANSIColor.reset)")
    }

    func showWelcome() {
        print("""
        
        \(ANSIColor.yellow)╔═══════════════════════════════════════╗
        ║      CRYSTALS AND DRAGONS 🐉          ║
        ╚═══════════════════════════════════════╝\(ANSIColor.reset)
        
        \(ANSIColor.cyan)GOAL:\(ANSIColor.reset) Find the key, find the chest, open it!
        
        \(ANSIColor.cyan)COMMANDS:\(ANSIColor.reset)
          N, S, W, E    - move in a direction
          get food      - pick up an item
          drop sword    - drop an item
          open          - open the chest (need key!)
          eat food      - restore health
          fight         - fight a monster (need sword!)
        
        \(ANSIColor.cyan)ITEMS:\(ANSIColor.reset) key, chest, torchlight, sword, food, gold
        
        \(ANSIColor.yellow)Good luck, brave adventurer! ⚔️\(ANSIColor.reset)
        """)
    }
    
    // MARK: - Input
    
    func getInput() -> String {
        print("> ", terminator: "")
        return readLine() ?? ""
    }
}
