class Maze {
    let width: Int
    let height: Int
    var rooms: [[Room]]
    
    init(roomCount: Int) {
        // Calculate grid dimensions close to a square
        let side = Int(Double(roomCount).squareRoot())
        self.width = side
        self.height = side
        
        // Grid of rooms
        var grid: [[Room]] = []
        for y in 0..<side {
            var row: [Room] = []
            for x in 0..<side {
                row.append(Room(x: x, y: y))
            }
            grid.append(row)
        }
        self.rooms = grid
    }
    
    func generate() {
        var visited = Set<String>()
        
        func key(_ x: Int, _ y: Int) -> String {
            return "\(x),\(y)"
        }
        
        // MARK: - Depth-First Search Algorithm
        func dfs(x: Int, y: Int) {
            visited.insert(key(x, y))
            
            // shuffle directions to get random maze each time
            let directions = Direction.allCases.shuffled()
            
            for direction in directions {
                let nx: Int
                let ny: Int
                
                switch direction {
                case .north: nx = x; ny = y - 1
                case .south: nx = x; ny = y + 1
                case .east: nx = x + 1; ny = y
                case .west: nx = x - 1; ny = y
                }
                
                // check bounds and not visited
                guard nx >= 0, nx < width,
                      ny >= 0, ny < height,
                      !visited.contains(key(nx, ny)) else { continue }
                
                // open doors between current and neighbor
                rooms[y][x].doors.insert(direction)
                rooms[ny][nx].doors.insert(direction.opposite)
                
                dfs(x: nx, y: ny)
            }
        }
        
        dfs(x: 0, y: 0)
    }
    
    func placeItems() {
        // place key and chest in random different rooms, not the start room
        var availableRooms = rooms.flatMap { $0 }.filter { !($0.x == 0 && $0.y == 0 ) }
        availableRooms.shuffle()
        
        guard availableRooms.count >= 4 else {
            print("Not enought rooms to place items. Please enter a larger number.")
            return
        }
        
        availableRooms[0].items.append(Item(type: .key, name: "key"))
        availableRooms[1].items.append(Item(type: .chest, name: "chest"))
        availableRooms[2].items.append(Item(type: .torchlight, name: "torchlight"))
        availableRooms[3].items.append(Item(type: .sword, name: "sword"))
        
        // place food in a few random rooms
        for i in 4..<min(7, availableRooms.count) {
            availableRooms[i].items.append(Item(type: .food(restoreAmount: 10), name: "food"))
        }
        
        // place gold in random rooms
        for i in stride(from: 0, to: availableRooms.count, by: 3) {
            let coins = Int.random(in: 50...500)
            availableRooms[i].items.append(Item(type: .gold(coins: coins), name: "gold"))
        }
        
        // place dark rooms (about 1/4 of all rooms)
        let darkRooms = Array(availableRooms.dropFirst(8))
        for room in darkRooms.prefix(availableRooms.count / 4) {
            room.isDark = true
        }
        
        // place monsters (about 1/4 of all rooms)
        let monsterNames = ["Dragon", "Goblin", "Troll", "Orc"]
        let monsterCanditates = Array(availableRooms.dropFirst(4))
        for room in monsterCanditates.prefix(availableRooms.count / 4) {
            let name = monsterNames.randomElement()!
            room.monster = Monster(name: name)
        }
    }
}
