extension GameViewModel {
    func handleMove(_ command: String) {
        let direction: Direction
        
        switch command {
        case "n": direction = .north
        case "s": direction = .south
        case "e": direction = .east
        case "w": direction = .west
        default: return
        }
        
        guard player.currentRoom.doors.contains(direction) else {
            view.showMessage("There is no door in that direction.")
            return
        }
        
        let currentRoom = player.currentRoom
        let newX: Int
        let newY: Int
        
        switch direction {
        case .north: newX = currentRoom.x; newY = currentRoom.y - 1
        case .south: newX = currentRoom.x; newY = currentRoom.y + 1
        case .east: newX = currentRoom.x + 1; newY = currentRoom.y
        case .west: newX = currentRoom.x - 1; newY = currentRoom.y
        }
        
        player.previousRoom = player.currentRoom
        player.currentRoom = maze.rooms[newY][newX]
        player.health -= 1
        
        checkHealth()
        describeCurrentRoom()
    }
    
    func checkHealth() {
        guard player.health <= 0 else { return }
        view.showMessage("You died of hunger in the dark dungeon. GAME OVER.")
        isGameOver = true
    }
}
