import Foundation

class GameViewModel {
    
    // MARK: - Properties
    
    let maze: Maze
    let player: Player
    let view: ConsoleView
    var isGameOver: Bool = false
    
    // MARK: - Init
    
    init(roomCount: Int) {
        self.maze = Maze(roomCount: roomCount)
        self.maze.generate()
        self.maze.placeItems()
        
        let startRoom = maze.rooms[0][0]
        let health = roomCount * 3
        self.player = Player(startRoom: startRoom, health: health)
        self.view = ConsoleView()
    }
    
    // MARK: - Game Loop
    
    func start() {
        view.showMessage("Welcome to Crystals and Dragons!")
        describeCurrentRoom()
        
        while !isGameOver {
            let input = view.getInput()
            handleInput(input.lowercased().trimmingCharacters(in: .whitespaces))
        }
    }
    
    func describeCurrentRoom() {
        let room = player.currentRoom
        
        if room.isDark && !room.isLit && !player.hasItem(named: "torchlight") {
            view.showDarkRoom()
        } else {
            view.showRoomDescription(room, health: player.health)
            if let monster = room.monster {
                view.showMonster(monster)
            }
        }
    }
    
    func handleInput(_ input: String) {
        let parts = input.split(separator: " ").map(String.init)
        guard !parts.isEmpty else { return }
        
        let command = parts[0]
        let argument = parts.count > 1 ? parts[1] : nil
        
        switch command {
        case "n", "s", "w", "e":
            handleMove(command)
        case "get":
            if let item = argument {
                handleGet(item)
            } else {
                view.showMessage("Get what?")
            }
        case "drop":
            if let item = argument {
                handleDrop(item)
            } else {
                view.showMessage("Drop what?")
            }
        case "open":
            handleOpen()
        case "eat":
            if let item = argument {
                handleEat(item)
            } else {
                view.showMessage("Eat what?")
            }
        case "fight":
            handleFight()
        default:
            view.showMessage("Unknown command.")
        }
    }
}
