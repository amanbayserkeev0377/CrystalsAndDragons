import Foundation

class Maze {
    let width: Int
    let height: Int
    var rooms: [[Room]]
    
    init(roomCount: Int) {
        // Round up so we always have enough rooms
        let side = Int(ceil(Double(roomCount).squareRoot()))
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
    
    // MARK: - Generate Maze
    
    func generate() {
        var visited = Set<String>()
        
        func key(_ x: Int, _ y: Int) -> String {
            return "\(x),\(y)"
        }
        
        // Depth-First Search Algorithm
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
    
    // MARK: - Place Items
    
    func placeItems() {
        // place key and chest in random different rooms, not the start room
        var availableRooms = rooms.flatMap { $0 }.filter { !($0.x == 0 && $0.y == 0 ) }
        availableRooms.shuffle()
        
        guard availableRooms.count >= 4 else { return }
        
        availableRooms[0].items.append(Item(type: .key, name: "key"))
        availableRooms[1].items.append(Item(type: .chest, name: "chest"))
        availableRooms[2].items.append(Item(type: .torchlight, name: "torchlight"))
        availableRooms[3].items.append(Item(type: .sword, name: "sword"))
        
        // optional items only if enough rooms
        if availableRooms.count > 4 {
            for i in 4..<min(7, availableRooms.count) {
                availableRooms[i].items.append(Item(type: .food(restoreAmount: 10), name: "food"))
            }
        }
        
        // gold in every 3rd room
        for i in stride(from: 0, to: availableRooms.count, by: 3) {
            let coins = Int.random(in: 50...500)
            availableRooms[i].items.append(Item(type: .gold(coins: coins), name: "gold"))
        }
        
        // dark rooms and monsters only if enough rooms
        let darkCandidates = Array(availableRooms.dropFirst(4))
        for room in darkCandidates.prefix(availableRooms.count / 4) {
            room.isDark = true
        }
        
        let monsterNames = ["Dragon", "Goblin", "Troll", "Orc"]
        let monsterCandidates = Array(availableRooms.dropFirst(4))
        for room in monsterCandidates.prefix(availableRooms.count / 4) {
            let name = monsterNames.randomElement()!
            room.monster = Monster(name: name)
        }
    }
    
    // MARK: - Shortest Path
    
    func shortestPath(from start: Room, to target: Room) -> Int? {
        var visited = Set<String>()
        var queue: [(room: Room, distance: Int)] = [(start, 0)]
        
        func key(_ room: Room) -> String { "\(room.x), \(room.y)" }
        
        while !queue.isEmpty {
            let (current, distance) = queue.removeFirst()
            let currentKey = key(current)
            
            guard !visited.contains(currentKey) else { continue }
            visited.insert(currentKey)
            
            if current.x == target.x && current.y == target.y {
                return distance
            }
            
            // add all neighbors through open doors
            for direction in current.doors {
                let nx: Int
                let ny: Int
                switch direction {
                case .north: nx = current.x; ny = current.y - 1
                case .south: nx = current.x; ny = current.y + 1
                case .east: nx = current.x + 1; ny = current.y
                case .west: nx = current.x - 1; ny = current.y
                }
                guard nx >= 0, nx < width, ny >= 0, ny < height else { continue }
                queue.append((rooms[ny][nx], distance + 1))
            }
        }
        return nil
    }
    
    func isPlayable(health: Int) -> Bool {
        let start = rooms[0][0]
        
        // find key and chest rooms
        guard let keyRoom = rooms.flatMap({ $0 }).first(where: { $0.items.contains { $0.name == "key" } }),
              let chestRoom = rooms.flatMap({ $0 }).first(where: { $0.items.contains { $0.name == "chest" } }) else {
            return false
        }
        
        // check both are reachable within health limit
        guard let distToKey = shortestPath(from: start, to: keyRoom),
              let distKeyToChest = shortestPath(from: keyRoom, to: chestRoom) else {
            return false
        }
        
        // realistic path: start -> key -> chest, with some buffer
        let minStepsNeeded = distToKey + distKeyToChest
        return minStepsNeeded < health / 2
    }
}
